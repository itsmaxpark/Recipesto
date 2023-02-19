//
//  RPRecipeLabel.swift
//  Recipesto
//
//  Created by Max Park on 2/19/23.
//

import UIKit

class RPRecipeLabel: UILabel {

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
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }

        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font as Any])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height

        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }

        super.drawText(in: newRect)
    }
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
        numberOfLines = 3
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
