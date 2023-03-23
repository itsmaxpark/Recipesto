//
//  SwipeRootView.swift
//  Recipesto
//
//  Created by Max Park on 3/22/23.
//

import UIKit
import Combine

class SwipeRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: SwipeViewModel
    let input: PassthroughSubject<SwipeViewModel.Input, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    
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
    
    // MARK: - Methods
    init(frame: CGRect = .zero, viewModel: SwipeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        configureUI()
        configureButtons()
        bind()
        input.send(.viewDidAppear)
    }
    
    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
            case .fetchRecipeDidSucceed(let recipe):
                self?.nameLabel.text = recipe.name
                guard let url = recipe.thumbnailUrl else { return }
                self?.recipeCard.downloadImage(fromURL: url)
                // set time view
                let totalTime = recipe.totalTimeMinutes ?? 0
                let cookTime = recipe.cookTimeMinutes ?? 0
                let prepTime = recipe.prepTimeMinutes ?? 0
                self?.timeView.set(totalTime: totalTime, cookTime: cookTime, prepTime: prepTime)
            case .fetchRecipeDidFail(let error):
                print(error)
            case .toggleButtons(let isEnabled):
                self?.saveButton.isEnabled = isEnabled
                self?.discardButton.isEnabled = isEnabled
            }
        }.store(in: &cancellables)
    }
    
    private func configureButtons() {
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        discardButton.addTarget(self, action: #selector(didTapDiscardButton), for: .touchUpInside)
    }
    
    @objc private func didTapSaveButton() {
        // TODO - Persistance manager with Userdefaults
        // add recipe to favorites
        // keep track of recipes that have been shown already
        // prepare to show new recipe
        print("DidTapSaveButton")
        input.send(.didSwipeAction)
    }
    
    @objc private func didTapDiscardButton() {
        // keep track of recipes that have been shown already
        // prepare to show new recipe
        print("DidTapDiscardButton")
        input.send(.didSwipeAction)
    }
    
    private func configureUI() {

        let padding: CGFloat = 16
        
        addSubview(scrollView)
        useConstraints(scrollView, containerView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(nameLabel, recipeCard, timeView, saveButton, discardButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
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
