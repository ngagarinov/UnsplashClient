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
        static let estimatedHeight: CGFloat = 200
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataFetcher = NetworkDataFetcher()
    private var page = 1
    private var collectionId = ""
    private var photosCollection = [PhotoDetail]()
    
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
        dataFetcher.getCollectionPhotos(collectonId: String(id)) { (details) in
            self.photosCollection = details ?? []
            self.tableView.reloadData()
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
            page += 1
            
            dataFetcher.getCollectionPhotos(withNext: page, collectonId: collectionId) { collection in
                self.photosCollection.append(contentsOf: collection ?? [])
                self.tableView.reloadData()
            }
        }
    }
    
}
