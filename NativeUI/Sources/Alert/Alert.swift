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
    
    public enum Text {
        case string(String, UIFont)
        case attributedString(NSAttributedString)
    }
    
    /// default font: `UIFont.systemFont(ofSize: 17, weight: .semibold)`
    public let title: Text?
    /// default font: `UIFont.systemFont(ofSize: 13, weight: .regular)`
    public let message: Text?
    /// Custom view to use instead of message or in addition to message.
    public let contentView: UIView?
    
    public let tintColor: UIColor?
    
    public let actions: [Action]
    
    public init(title: Text?,
                message: Text?,
                contentView: UIView? = nil,
                tintColor: UIColor? = nil,
                actions: [Action]) {
        self.title = title
        self.message = message
        self.contentView = contentView
        self.tintColor = tintColor
        self.actions = actions
    }
    
    public init(title: String?,
                titleFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .semibold),
                message: String?,
                messageFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular),
                contentView: UIView? = nil,
                tintColor: UIColor? = nil,
                actions: [Action]) {
        self.init(title: title.map { .string($0, titleFont) },
                  message: message.map { .string($0, messageFont) },
                  contentView: contentView,
                  tintColor: tintColor,
                  actions: actions)
    }
    
    public init(title: NSAttributedString?,
                message: NSAttributedString?,
                contentView: UIView? = nil,
                tintColor: UIColor? = nil,
                actions: [Action]) {
        self.init(title: title.map { .attributedString($0) },
                  message: message.map { .attributedString($0) },
                  contentView: contentView,
                  tintColor: tintColor,
                  actions: actions)
    }
}
