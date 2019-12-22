//
//  PhotoDetailViewController.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 20.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    // MARK: - Constants
       
       private enum Constants {
           static let cellIdentificator = "PhotoDetialTableViewCell"
           static let estimatedHeight: CGFloat = 375
       }
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataFetcher = NetworkDataFetcher()
    private var photoDetail: PhotoDetail?
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewAppearance()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: Constants.cellIdentificator, bundle: nil), forCellReuseIdentifier: PhotoDetialTableViewCell.cellId)
    }
    
    // MARK: - Internal Properties
    
    func configure(with viewModel: PhotoDetail?) {
        
        photoDetail = viewModel
//        dataFetcher.getPhotoDetail(id: id) { (model) in
//            self.photoDetail = model
//            self.tableView.reloadData()
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.isHidden = true
//            self.tableView.isHidden = false
//        }
    }
}

// MARK: - Private PhotoDetailViewController Extension

private extension PhotoDetailViewController {
    
    func setTableViewAppearance() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = Constants.estimatedHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - TableViewDataSource Methods

extension PhotoDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoDetialTableViewCell.cellId, for: indexPath)
        
        if let photoCell = cell as? PhotoDetialTableViewCell {
            photoCell.configure(with: photoDetail)
        }

        return cell
    }
}

// MARK: TableViewDelegate Methods

extension PhotoDetailViewController: UITableViewDelegate {

}
