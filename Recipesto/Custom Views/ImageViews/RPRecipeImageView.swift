//
//  RPRecipeImageView.swift
//  Recipesto
//
//  Created by Max Park on 11/23/22.
//

import UIKit

class RPRecipeImageView: UIImageView {
    
//    let cache = NetworkManager.shared.cache
//    let placeholderImage = Images.placeholder

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
//        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromURL url: String) {
//        Task { image = await NetworkManager.shared.downloadImage(from: url) ?? placeholderImage }
    }
}
