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
    }
    
    // MARK: - Propeties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataFetcher = NetworkDataFetcher()
    private var collections = [Collections]()
    private var page = 1
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: Constants.cellIdentificator, bundle: nil), forCellReuseIdentifier: MainTableViewCell.cellId)
        
        dataFetcher.getCollections { collections in
            self.collections = collections ?? []
            self.tableView.reloadData()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(goToSearch))
        
    }
    
    // MARK: - Private Helpers
    
    @objc func goToSearch() {
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        navigationController?.pushViewController(searchVC, animated: true)
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
            
            dataFetcher.getCollections(withNext: page) { collection in
                self.collections.append(contentsOf: collection ?? [])
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionViewController: CollectionViewController = CollectionViewController.loadFromStoryboard()
        collectionViewController.photosCollection = collections[indexPath.row].previewPhotos
//        collectionViewController.configure(with: collections[indexPath.row].previewPhotos)
        
        self.navigationController?.pushViewController(collectionViewController, animated: true)
    }
}

////MARK: - UnsplashPhotoPickerDelegate
//extension MainViewController: UnsplashPhotoPickerDelegate {
//    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
//        print("Unsplash photo picker did select \(photos.count) photo(s)")
//
//        self.collections = photos
//
//        tableView.reloadData()
//    }
//
//    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
//        print("Unsplash photo picker did cancel")
//    }
//}
