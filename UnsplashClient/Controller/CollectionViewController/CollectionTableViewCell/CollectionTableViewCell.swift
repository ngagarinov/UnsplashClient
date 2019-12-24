//
//  CollectionTableViewCell.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 20.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit
import Nuke

class CollectionTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Properties
    
    static let cellId = "CollectionCell"
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Cell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        photoImageView.layer.cornerRadius = Constants.cornerRadius
//        photoImageView.clipsToBounds = true
    }
    
    // MARK: - Internal Helpers
    
    func configure(with model: PhotoDetail) {
        photoImageView.loadImage(with: model.urls.regular, placeholder: UIImage(named: "placeholder"))
        if let username = model.user?.name {
            usernameLabel.text = username
        }
    }
}
