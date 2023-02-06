//
//  IngredientCell.swift
//  Recipesto
//
//  Created by Max Park on 2/5/23.
//


import UIKit

class IngredientCell: UITableViewCell {
    static let identifier = "IngredientCell"
    
    let nameLabel = RPBodyLabel(textAlignment: .left)
    let amountLabel = RPBodyLabel(textAlignment: .right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func set(component: Component) {
        let ingredient = component.ingredient
        let ingredientName = ingredient.name
        nameLabel.text = ingredientName
        
        let measurements = component.measurements
        
        let measurement: Measurement!
        if measurements.count == 2 {
            if measurements[0].unit.system == "metric" {
                measurement = measurements[1]
            } else {
                measurement = measurements[0]
            }
        } else {
            measurement = measurements[0]
        }
        let quantity = measurement.quantity
        let unit = measurement.unit
        let unitName = unit.name
        amountLabel.text = quantity + " " + unitName
    }
    
    func configure() {
        addSubviews(nameLabel, amountLabel)
        
        let padding: CGFloat = 6
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.widthAnchor.constraint(equalToConstant: 200),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.0),
            
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 8),
            amountLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 40),
//            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            amountLabel.widthAnchor.constraint(equalToConstant: 100),
            amountLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.0)
        ])
    }
}
