//
//  AlertViewController.swift
//  NativeUI
//
//  Created by Anton Poltoratskyi on 05.04.2020.
//  Copyright © 2020 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public final class AlertViewController: UIViewController, AlertViewDelegate {
    
    public var shouldDismissAutomatically: Bool = true
    
    private var viewModel: Alert
    
    // MARK: - Subviews
    
    private(set) lazy var alertView: AlertView = {
        let alertView = AlertView()
        alertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertView)
        return alertView
    }()
    
    // MARK: - Init
    
    public init(viewModel: Alert) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        setupViewModel()
    }
    
    // MARK: - Public Interface
    
    public func addAction(_ action: Alert.Action) {
        viewModel.addAction(action)
    }
    
    // MARK: - UI Setup
    
    private func setupAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        if let tintColor = viewModel.tintColor {
            view.tintColor = tintColor
        }
    }
    
    private func setupLayout() {
        let safeAreaLayoutGuide: UILayoutGuide
        if #available(iOS 11.0, *) {
            safeAreaLayoutGuide = view.safeAreaLayoutGuide
        } else {
            let layoutGuide = UILayoutGuide()
            view.addLayoutGuide(layoutGuide)
            
            NSLayoutConstraint.activate([
                layoutGuide.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                layoutGuide.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
            safeAreaLayoutGuide = layoutGuide
        }
        
        NSLayoutConstraint.activate([
            alertView.widthAnchor.constraint(equalToConstant: Layout.width),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            alertView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: Layout.verticalInset)
        ])
    }
    
    private func setupViewModel() {
        alertView.delegate = self
        alertView.setup(viewModel: viewModel)
    }
    
    // MARK: - Layout
    
    private enum Layout {
        static let verticalInset: CGFloat = 44
        static let width: CGFloat = 270
    }
}

// MARK: - AlertViewDelegate

extension AlertViewController {
    
    func alertView(_ alertView: AlertView, buttonTappedAtIndex index: Int) {
        if viewModel.actions.indices.contains(index) {
            let action = viewModel.actions[index]
            action.handler?(action)
        }
        if shouldDismissAutomatically {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension AlertViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertPresentationAnimator()
    }
    
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertPresentationAnimator()
    }
}
