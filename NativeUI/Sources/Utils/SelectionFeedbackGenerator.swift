//
//  SelectionFeedbackGenerator.swift
//  NativeUI
//
//  Created by Anton Poltoratskyi on 05.04.2020.
//  Copyright © 2020 Anton Poltoratskyi. All rights reserved.
//

import UIKit

private protocol SelectionFeedbackInteractive: AnyObject {
    func prepare()
    func selectionChanged()
}

@available(iOS 10.0, *)
extension UISelectionFeedbackGenerator: SelectionFeedbackInteractive { }

/// Backward compatible wrapper for native `UISelectionFeedbackGenerator`.
public final class SelectionFeedbackGenerator {
    
    private let generator: SelectionFeedbackInteractive?
    
    public init() {
        if #available(iOS 10.0, *) {
            generator = UISelectionFeedbackGenerator()
        } else {
            generator = nil
        }
    }
    
    public func prepare() {
        generator?.prepare()
    }
    
    public func selectionChanged() {
        generator?.selectionChanged()
    }
}
