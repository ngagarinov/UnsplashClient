//
//  PhotoDetailViewController.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 20.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    private var dataFetcher = NetworkDataFetcher()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Internal Properties
    
    func configure(with id: String) {
        
        dataFetcher.getPhotoDetail(id: id) { (model) in
            if let model = model {
                self.widthLabel.text = String(model.width)
                self.heightLabel.text = String(model.height)
                if let description = model.description {
                    self.descriptionLabel.text = description
                } else {
                    self.descriptionLabel.isHidden = true
                }
                
                self.urlLabel.text = model.urls.regular
            }
        }
    }
    
    
}
