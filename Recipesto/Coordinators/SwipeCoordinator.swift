//
//  SwipeCoordinator.swift
//  Recipesto
//
//  Created by Max Park on 3/23/23.
//

import UIKit

class SwipeCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    var viewModel = SwipeViewModel()
    lazy var swipeVC = SwipeVC(viewModel: viewModel)
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        rootViewController.setViewControllers([swipeVC], animated: true)
    }
}
