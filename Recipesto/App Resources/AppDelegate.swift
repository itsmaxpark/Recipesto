//
//  AppDelegate.swift
//  Recipesto
//
//  Created by Max Park on 11/15/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appCoordinator: RPAppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appCoordinator = RPAppCoordinator(window: window)
        appCoordinator.start()
        
        self.appCoordinator = appCoordinator
        window.makeKeyAndVisible()
        return true
    }
}

