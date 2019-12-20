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
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var photosCollection = [PhotosCollection]()
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UINib(nibName: Constants.cellIdentificator, bundle: nil), forCellReuseIdentifier: CollectionTableViewCell.cellId)
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
    
    func configure( with model: [PhotosCollection]) {
        photosCollection = model
        tableView.reloadData()
    }
    
}

// MARK: - TableViewDelegate Methods

extension CollectionViewController: UITableViewDelegate {
    
    
}
