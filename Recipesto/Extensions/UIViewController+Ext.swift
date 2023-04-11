//
//  UIViewController+Ext.swift
//  UIViewController extensions

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    
    /// Presents a modal popup alert to the current ViewController with custom parameters for the title, message, and button title
    func presentRPAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = RPAlertVC(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    /// Presents a default alert modal popup with a default title, message, and button title
    func presentDefaultAlert() {
        let alertVC = RPAlertVC(
            title: "Something went wrong",
            message: "Unable to complete task. Try again later",
            buttonTitle: "Ok"
        )
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    /// Presents an activity indicator spinner for indicating loading states
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        view.addSubview(containerView)
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    /// Dismisses the activity indicator
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
}
