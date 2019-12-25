//
//  CollectionViewController.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 20.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit
import SwiftMessages

class CollectionViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cellIdentificator = "CollectionTableViewCell"
        static let estimatedHeight: CGFloat = 138
        static let errorNotificationSeconds: TimeInterval = 5
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadButton: UIButton!
    
    private var dataFetcher = NetworkDataFetcher()
    private var page = 1
    private var collectionId = ""
    private var photosCollection = [PhotoDetail]()
    lazy private var spinner : SYActivityIndicatorView = {
        return SYActivityIndicatorView(image: nil)
    }()
    lazy private var errorMessageView: MessageView = {
        return MessageView().configureErrorView()
    }()
    var totalPhotos = 0
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setBlurEffect()
  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Internal Helpers
    
    func makeRequest(with id: Int) {
        collectionId = String(id)
        dataFetcher.getCollectionPhotos(collectonId: String(id)) { result in
            switch result {
            case .data(let details):
                self.photosCollection = details
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.tableView.isHidden = false
            case .error:
                self.showErrorNotification()
                self.spinner.stopAnimating()
                self.reloadButton.isHidden = false
                
            }
        }
    }
}

// MARK: - Private CollectionViewController Extension

private extension CollectionViewController {
    
    @objc func reloadRequest() {
        if let id = Int(collectionId) {
            makeRequest(with: id)
        }
    }
    
    func setBlurEffect() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
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
    
    func setTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = Constants.estimatedHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        self.tableView.register(UINib(nibName: Constants.cellIdentificator, bundle: nil), forCellReuseIdentifier: CollectionTableViewCell.cellId)
        
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        reloadButton.isHidden = true
        reloadButton.addTarget(self, action: #selector(reloadRequest), for: .touchUpInside)
    }
    
    func showErrorNotification()  {
        errorMessageView.isHidden = false
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: Constants.errorNotificationSeconds)
        SwiftMessages.show(config: config, view: errorMessageView)
    }
}


// MARK: - TableViewDataSource Methods

extension CollectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.cellId, for: indexPath)

        if let photoCell = cell as? CollectionTableViewCell {
            photoCell.configure(with: photosCollection[indexPath.row])
        }

        return cell
    }
    
    // MARK: - Internal Helpers
    
}

// MARK: - TableViewDelegate Methods

extension CollectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let photoDetailVC: PhotoDetailViewController = PhotoDetailViewController.loadFromStoryboard()
        photoDetailVC.configure(with: photosCollection[indexPath.row])
        photoDetailVC.title = photosCollection[indexPath.row].user?.name
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == photosCollection.count - 1 {
            if totalPhotos > photosCollection.count {
                page += 1
                
                dataFetcher.getCollectionPhotos(withNext: page, collectonId: collectionId) { result in
                    switch result {
                    case .data( let collection):
                        self.photosCollection.append(contentsOf: collection)
                        self.tableView.reloadData()
                    case .error:
                        print("error")
                    }
                }
            }
        }
    }
}
