//
//  CollectionViewController.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 20.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cellIdentificator = "CollectionTableViewCell"
        static let estimatedHeight: CGFloat = 138
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataFetcher = NetworkDataFetcher()
    private var page = 1
    private var collectionId = ""
    private var photosCollection = [PhotoDetail]()
    lazy private var spinner : SYActivityIndicatorView = {
        return SYActivityIndicatorView(image: nil)
    }()
    var totalPhotos = 0
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewAppearance()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UINib(nibName: Constants.cellIdentificator, bundle: nil), forCellReuseIdentifier: CollectionTableViewCell.cellId)
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
                print("error")
            }
            
        }
    }
}

// MARK: - Private CollectionViewController Extension

private extension CollectionViewController {
    
    func setTableViewAppearance() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = Constants.estimatedHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        spinner.center = view.center
        view.addSubview(spinner)
        tableView.isHidden = true
        spinner.startAnimating()
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
