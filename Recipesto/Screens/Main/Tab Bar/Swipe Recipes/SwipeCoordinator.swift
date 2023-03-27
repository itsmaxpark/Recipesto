//
//  SwipeCoordinator.swift
//  The Coordinator for the SwipeVC

import UIKit

class SwipeCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        let viewModel = SwipeViewModel()
        viewModel.coordinator = self
        
        let swipeVC = SwipeVC(viewModel: viewModel)
        rootViewController.setViewControllers([swipeVC], animated: true)
    }
}
