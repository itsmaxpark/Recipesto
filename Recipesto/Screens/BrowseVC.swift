//
//  BrowseVC.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class BrowseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        
        Task {
            do {
                let featuredResponse: [String: [Result]] = try await NetworkManager.shared.getFeaturedRecipes(page: 0, isVegetarian: false)
                print("Success")
                guard let featuredResults = featuredResponse["results"] else {
                    return
                }
                print(featuredResults.count)
                for result in featuredResults {
                    print(result.name ?? "No name")
                }
                
            } catch {
                if let rpError = error as? RPError {
                    presentRPAlert(title: "Uh oh", message: rpError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultAlert()
                }
//                dismissLoadingView()
            }
        }
        
        
    }
}
