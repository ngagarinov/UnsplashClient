//
//  PhotoDetialTableViewCell.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 21.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit

class PhotoDetialTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellId = "DetailCell"
    
    @IBOutlet weak var resolutionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlTextView: UITextView!
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // MARK: - Internal Helpers
    
    func configure( with model: PhotoDetail? ) {
        if let viewModel = model {
            resolutionLabel.text = "\(viewModel.width)x\(viewModel.height)"
            if let description = viewModel.description {
                descriptionLabel.text = description
            } else {
                descriptionLabel.isHidden = true
            }
            photoImageView.loadImage(with: viewModel.urls.regular)
            urlTextView.text = viewModel.urls.full
            
        }
    }
    
    
}
