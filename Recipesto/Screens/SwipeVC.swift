//
//  SearchVC.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class SwipeVC: UIViewController {
    
    var recipe: Item?
    
    var scrollView = UIScrollView(frame: .zero)
    var containerView = UIView(frame: .zero)
    var nameLabel = RPTitleLabel(textAlignment: .left, fontSize: 28)
    var recipeCard = RPRecipeImageView(frame: .zero)
    var timeView = RPTimeView()
    var saveButton: LSImageButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        let button = LSImageButton(color: .systemGreen, systemImageName: "heart.fill", configuration: config)
        return button
    }()
    var discardButton: LSImageButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        let button = LSImageButton(color: .systemRed, systemImageName: "x.circle.fill", configuration: config)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureButtons()
        getRecipe()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if let timeView {
//            timeView.removeFromSuperview()
//        }
    }
    
    /// Receives a random recipe from the network call to be used for display
    /// On success, updates the UI with the corresponding recipe
    private func getRecipe() {
        
        showLoadingView()
        
        Task {
            let recipesResponse: RecipeResult
            
            do {
                recipesResponse = try await NetworkManager.shared.getRandomRecipe(page: 0, isVegetarian: false, tags: "")
                let recipes = recipesResponse.results
                guard let recipe = recipes.randomElement() else { return }
                self.recipe = recipe
                updateUI(with: recipe)
                configureUI()
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
    
    /// Set the UI with the recipe from a network call
    /// - Parameter with: Item - the recipe to be shown
    private func updateUI(with: Item) {
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
        timeView.set(totalTime: totalTime, cookTime: cookTime, prepTime: prepTime)
    }
    
    private func configureButtons() {
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        discardButton.addTarget(self, action: #selector(didTapDiscardButton), for: .touchUpInside)
    }
    
    private func configureVC() {
        view.backgroundColor = .secondarySystemBackground
        scrollView.delegate = self
    }
    
    @objc private func didTapSaveButton() {
        // TODO - Persistance manager with Userdefaults
        // add recipe to favorites
        // keep track of recipes that have been shown already
        // prepare to show new recipe
        getRecipe()
    }
    
    @objc private func didTapDiscardButton() {
        // keep track of recipes that have been shown already
        // prepare to show new recipe
        getRecipe()
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

// MARK: - Scroll View Delegate
extension SwipeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

// MARK: - Constraints
extension SwipeVC {
    
    private func configureUI() {

        let padding: CGFloat = 16
        
        view.addSubview(scrollView)
        view.useConstraints(scrollView, containerView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(nameLabel, recipeCard, timeView, saveButton, discardButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 80),
            
            recipeCard.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            recipeCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            recipeCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            recipeCard.heightAnchor.constraint(equalTo: recipeCard.widthAnchor),
            
            timeView.topAnchor.constraint(equalTo: recipeCard.bottomAnchor, constant: padding),
            timeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            timeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            timeView.heightAnchor.constraint(equalToConstant: 40),
            
            discardButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            discardButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            discardButton.widthAnchor.constraint(equalToConstant: 80),
            discardButton.heightAnchor.constraint(equalToConstant: 80),
            
            saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            saveButton.widthAnchor.constraint(equalToConstant: 80),
            saveButton.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
}
