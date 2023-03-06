//
//  RPBarButton.swift
//  Recipesto
//
//  Created by Max Park on 3/5/23.
//

import UIKit

class RPBarButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    convenience init(image: UIImage?) {
        self.init(frame: .zero)
        set(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        tintAdjustmentMode = .normal
    }
    
    private func set(image: UIImage?) {
        setImage(image, for: .normal)
    }
}
