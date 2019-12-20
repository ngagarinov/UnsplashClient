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
    
    // MARK: - Properties
    
    static let cellId = "CollectionCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Cell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Internal Helpers
    
    func configure(with model: PhotosCollection) {
        photoImageView.loadImage(with: model.urls.regular)
    }
}
