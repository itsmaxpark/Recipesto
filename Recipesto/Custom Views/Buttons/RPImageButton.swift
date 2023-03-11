//
//  RPBarButton.swift
//  Recipesto
//
//  Created by Max Park on 3/5/23.
//

import UIKit

class RPImageButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    convenience init(color: UIColor, image: UIImage?) {
        self.init(frame: .zero)
        guard let image = image else { return }
        set(color: color, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .capsule
        configuration?.buttonSize = .large
        configuration?.imagePadding = 0
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView?.contentMode = .scaleAspectFit
    }
    
    final func set(color: UIColor, image: UIImage) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.image = image
    }
}

// MARK: - Custom Image Button
class LSImageButton: UIButton {
    init(color: UIColor, image: UIImage?) {
        super.init(frame: .zero)
        setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        imageView?.image?.withTintColor(color)
        imageView?.bounds = bounds
        translatesAutoresizingMaskIntoConstraints = false
        tintAdjustmentMode = .normal
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, systemImageName: String, configuration: UIImage.SymbolConfiguration) {
        self.init(frame: .zero)
        let image = UIImage(systemName: systemImageName, withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        imageView?.tintColor = color
        translatesAutoresizingMaskIntoConstraints = false
        tintAdjustmentMode = .normal
    }
}

