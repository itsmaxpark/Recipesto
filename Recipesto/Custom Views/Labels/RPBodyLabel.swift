//
//  RPBodyLabel.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class RPBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
    }
    
    private func configure() {
        textColor = .secondaryLabel
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
