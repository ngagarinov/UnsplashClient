//
//  SearchViewController.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 20.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

final class SearchViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    private var photos = [UnsplashPhoto]()
    
    // MARK: - IBAction
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: SecretConstants.accessKey,
            secretKey: SecretConstants.secretKey,
            query: searchTextField.text
        )
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = self

        present(unsplashPhotoPicker, animated: true, completion: nil)
    }
}

// MARK: - UnsplashPhotoPickerDelegate

extension SearchViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {

        if let photo = photos[0].urls[.regular] {
            imageView.loadImage(with: photo, placeholder: UIImage(named: "placeholder"))
        }
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
