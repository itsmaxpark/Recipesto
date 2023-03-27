//
//  RPAppCoordinator.swift
//  The top level coordinator for Recipesto

import UIKit

class RPAppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = .init()
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    /// Inits and sets the main app window to a TabBarController and Coordinator
    func start() {
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.start()
        self.childCoordinators = [tabBarCoordinator]
        window.rootViewController = tabBarCoordinator.rootViewController
    }
}
