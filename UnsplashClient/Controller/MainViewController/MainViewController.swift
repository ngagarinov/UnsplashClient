//
//  MainViewController.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 18.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

final class MainViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cellIdentificator = "MainTableViewCell"
        static let estimatedHeight: CGFloat = 267
    }
    
    // MARK: - Propeties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoOfTheDay: UIImageView!
    @IBOutlet weak var PhotoOfTheDayUsernameLabel: UILabel!
    
    lazy private var spinner : SYActivityIndicatorView = {
        return SYActivityIndicatorView(image: nil)
    }()
    
    private var dataFetcher = NetworkDataFetcher()
    private var collections = [Collections]()
    private var page = 1
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setSpinner()
        setBlurEffect()
        setTableView()
        networkRequests()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(goToSearch))
        
    }
    
    // MARK: - Private Helpers
    
    @objc func goToSearch() {
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        navigationController?.pushViewController(searchVC, animated: true)
    }

}

// MARK: - Private MainViewController Extension

private extension MainViewController {
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: Constants.cellIdentificator, bundle: nil), forCellReuseIdentifier: MainTableViewCell.cellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = Constants.estimatedHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setBlurEffect() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        var bounds = navigationBar.bounds
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        bounds.size.height += statusBarHeight
        bounds.origin.y -= statusBarHeight
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationBar.addSubview(visualEffectView)
        visualEffectView.layer.zPosition = -1
    }
    
    func setSpinner() {
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        tableView.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func networkRequests() {
        dataFetcher.getCollections { result in
            switch result {
            case .data(let collections):
                self.collections = collections
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.tableView.isHidden = false
                self.navigationController?.setNavigationBarHidden(false, animated: false)
            case .error:
                print("error")
            }
            
        }
        dataFetcher.getPhotoOfTheDay { result in
            switch result {
            case .data(let photo):
                self.photoOfTheDay.loadImage(with: photo.coverPhoto.urls.small)
                self.tableView.reloadData()
                if let username = photo.coverPhoto.user?.name {
                    self.PhotoOfTheDayUsernameLabel.text = "by \(username)"
                }
            case .error:
                print("error")
            }
        }
    }
}

// MARK: - TableViewDataSource Methods

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellId, for: indexPath)

        if let collectionCell = cell as? MainTableViewCell {
            let collection = collections[indexPath.row]
            collectionCell.configure(with: collection)
        }

        return cell
    }
}

// MARK: - TableViewDelegate Methods

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == collections.count - 1 {
            page += 1
            
            dataFetcher.getCollections(withNext: page) { result in
                switch result {
                case .data(let collection):
                    self.collections.append(contentsOf: collection )
                    self.tableView.reloadData()
                case .error:
                    print("error")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let collectionViewController: CollectionViewController = CollectionViewController.loadFromStoryboard()
        collectionViewController.makeRequest(with: collections[indexPath.row].id)
        collectionViewController.totalPhotos = collections[indexPath.row].totalPhotos
        
        self.navigationController?.pushViewController(collectionViewController, animated: true)
    }
    
}

