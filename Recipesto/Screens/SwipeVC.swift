//
//  SearchVC.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class SwipeVC: UIViewController {
    
    var scrollView = UIScrollView(frame: .zero)
    var nameLabel = RPTitleLabel(textAlignment: .left, fontSize: 28)
    var recipeCard = RPRecipeImageView(frame: .zero)
    var timeView: RPTimeView!
    var saveButton = RPImageButton(image: SFSymbols.filledHeart)
    var discardButton = RPImageButton(image: SFSymbols.xMark)
    
    var recipe: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNewRecipe()
    }
    
    private func showNewRecipe() {
        // retrieve random recipe
        getRecipe()
        guard let recipe = recipe else { return }
        // set name label
        nameLabel.text = recipe.name
        // set recipe card
        guard let url = recipe.thumbnailUrl else { return }
        recipeCard.downloadImage(fromURL: url)
        // set time view
        let totalTime = recipe.totalTimeMinutes ?? 0
        let cookTime = recipe.cookTimeMinutes ?? 0
        let prepTime = recipe.prepTimeMinutes ?? 0
        timeView = RPTimeView(totalTime: totalTime, cookTime: cookTime, prepTime: prepTime)
        configureUI()
    }
    
    private func getRecipe() {
        showLoadingView()
        Task {
            let recipesResponse: ListReponse
            
            do {
                recipesResponse = try await NetworkManager.shared.getRandomRecipe(page: 0, isVegetarian: false, tags: "")
                let recipes = recipesResponse.results
                recipe = recipes.randomElement()!
                dismissLoadingView()
                
            } catch {
                if let rpError = error as? RPError {
                    presentRPAlert(title: "Uh oh", message: rpError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultAlert()
                }
                dismissLoadingView()
            }
        }
    }
    
    private func configureVC() {
        view.backgroundColor = .systemRed
        scrollView.delegate = self
    }
    
    private func configureUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubviews(nameLabel, recipeCard, timeView, saveButton, discardButton)
        
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 80),
            
            recipeCard.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            recipeCard.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            recipeCard.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            recipeCard.heightAnchor.constraint(equalToConstant: 200),
            
            timeView.topAnchor.constraint(equalTo: recipeCard.bottomAnchor, constant: padding),
            timeView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            timeView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            timeView.heightAnchor.constraint(equalToConstant: 40),
            
            discardButton.topAnchor.constraint(equalTo: timeView.bottomAnchor, constant: padding),
            discardButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            discardButton.widthAnchor.constraint(equalToConstant: 40),
            discardButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.topAnchor.constraint(equalTo: timeView.bottomAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            saveButton.widthAnchor.constraint(equalToConstant: 40),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

extension SwipeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
