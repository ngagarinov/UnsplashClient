//
//  MainTableViewCell.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 19.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    static let cellId = "MainCell"
    
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
    
    func configure(with model: Collections) {
        titleLabel.text = model.title
    }
    
}
