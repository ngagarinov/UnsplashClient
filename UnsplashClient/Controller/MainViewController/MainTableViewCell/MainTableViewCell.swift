//
//  MainTableViewCell.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 19.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var roundView: UIView!
    
    static let cellId = "MainCell"
    
    // MARK: - Cell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        roundView.layer.masksToBounds = true
        roundView.layer.cornerRadius = Constants.cornerRadius
    }
    
    // MARK: - Internal Helpers
    
    func configure(with model: Collections) {
        titleLabel.text = model.title
        if let description = model.description {
          descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        coverImage.loadImage(with: model.coverPhoto.urls.regular, placeholder: UIImage(named: "placeholder"))
    }
    
}
