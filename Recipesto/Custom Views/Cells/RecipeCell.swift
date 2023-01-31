//
//  RecipeCell.swift
//  Recipesto
//
//  Created by Max Park on 11/23/22.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    static let identifier = "RecipeCell"
    
    let recipeImageView = RPRecipeImageView(frame: .zero)
    let recipeLabel = RPTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func set(recipe: Item) {
        print(recipe)
        guard let urlString = recipe.thumbnailUrl else {
            print("recipe set failed")
            return
        }
        recipeLabel.text = recipe.name
        recipeImageView.downloadImage(fromURL: urlString)
        print("recipe set")
    }
    
    private func configure() {
        
        addSubviews(recipeImageView, recipeLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor),
            
            recipeLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 12),
            recipeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            recipeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            recipeLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
