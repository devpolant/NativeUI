//
//  ViewController.swift
//  NativeUIExample
//
//  Created by Anton Poltoratskyi on 05.04.2020.
//  Copyright © 2020 Anton Poltoratskyi. All rights reserved.
//

import UIKit
import NativeUI

final class ViewController: UIViewController {
    
    enum Appearance: Int {
        case `default`  = 0
        case custom     = 1
    }
    
    @IBOutlet private var segmentedControl: UISegmentedControl!
    
    @IBAction private func showAlert() {
        guard let appearance = Appearance(rawValue: segmentedControl.selectedSegmentIndex) else {
            return
        }
        switch appearance {
        case .default:
            let cancelAction = Alert.Action(title: "Cancel", style: .primary)
            let confirmAction = Alert.Action(title: "Confirm", style: .default)
            
            let viewModel = Alert(
                title: "Your Title",
                message: "Your Message",
                actions: [cancelAction, confirmAction]
            )
            let alert = AlertViewController(viewModel: viewModel)
            present(alert, animated: true)
            
        case .custom:
            let cancelAction = Alert.Action(title: "Cancel", style: .primary)
            let confirmAction = Alert.Action(title: "Confirm", style: .default)
            
            let customView = CustomView()
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.imageView.backgroundColor = .orange
            customView.titleLabel.text = "Some text"
            customView.subtitleLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            
            let viewModel = Alert(
                title: "Your Title",
                message: nil,
                contentView: customView,
                actions: [cancelAction, confirmAction]
            )
            let alert = AlertViewController(viewModel: viewModel)
            present(alert, animated: true)
        }
    }
}
