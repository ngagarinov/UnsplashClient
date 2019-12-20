//
//  SearchViewController.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 20.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class SearchViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    private var photos = [UnsplashPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "77b6e0e583382304914b61409589def5766f0f26510379702a3b0ae7db44c8fa",
            secretKey: "5d5215ced1a7430a91b6a6508286480a86adcd6ed31b8dd4b1870c5dc4763686",
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

        if let photo = photos.first!.urls[.regular] {
            imageView.loadImage(with: photo, placeholder: nil)
        }
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Unsplash photo picker did cancel")
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
