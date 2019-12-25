//
//  MessageView.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 25.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit
import SwiftMessages

extension MessageView {
    
    private enum Constants {
        static let messageViewEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        static let error = "Ошибка"
        static let checkConnection = "Проверьте соединение с интернетом"
    }
    
    func configureErrorView() -> MessageView {
        let messageView = MessageView.viewFromNib(layout: .messageView)
        messageView.configureTheme(.error)
        messageView.configureDropShadow()
        messageView.iconLabel?.isHidden = true
        messageView.button?.isHidden = true
        messageView.configureContent(title: Constants.error, body: Constants.checkConnection)
        messageView.layoutMarginAdditions = Constants.messageViewEdgeInsets
        return messageView
    }
}
