//
//  RPAppCoordinator.swift
//  Recipesto
//
//  Created by Max Park on 3/23/23.
//

import UIKit

class RPAppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = .init()
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        print("App Coordinator Start")
        // launch tab bar controller
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.start()
        self.childCoordinators = [tabBarCoordinator]
        window.rootViewController = tabBarCoordinator.rootViewController
    }
}
