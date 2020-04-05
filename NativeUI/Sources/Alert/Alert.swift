//
//  Alert.swift
//  NativeUI
//
//  Created by Anton Poltoratskyi on 05.04.2020.
//  Copyright © 2020 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public struct Alert {
    public struct Action {
        public typealias Handler = (Alert.Action) -> Void
        
        public enum Style {
            case `default`
            case primary
            case custom(font: UIFont, textColor: UIColor)
        }
        public let title: String
        public let style: Style
        public let handler: Handler?
        
        public init(title: String, style: Style, handler: Handler? = nil) {
            self.title = title
            self.style = style
            self.handler = handler
        }
    }
    
    public let title: String?
    public let titleFont: UIFont
    public let message: String?
    public let messageFont: UIFont
    public let contentView: UIView?
    public let tintColor: UIColor?
    public let actions: [Action]
    
    public init(title: String?,
                titleFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .semibold),
                message: String?,
                messageFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular),
                contentView: UIView? = nil,
                tintColor: UIColor? = nil,
                actions: [Action]) {
        self.title = title
        self.titleFont = titleFont
        self.message = message
        self.messageFont = messageFont
        self.contentView = contentView
        self.tintColor = tintColor
        self.actions = actions
    }
}
