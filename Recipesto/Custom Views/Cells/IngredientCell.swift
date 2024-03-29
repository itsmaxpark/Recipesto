//
//  IngredientCell.swift
//  Recipesto
//
//  Created by Max Park on 2/5/23.
//


import UIKit

class IngredientCell: UITableViewCell {
    static let identifier = "IngredientCell"
    
    let nameLabel = RPBodyLabel(textAlignment: .left, fontSize: 14)
    let amountLabel = RPTitleLabel(textAlignment: .right, fontSize: 14)
    
    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Remove seperator line from top and bottom of each section header
    override func layoutSubviews(){
        super.layoutSubviews()
        
        let width = subviews[0].frame.width

        for view in subviews where view != contentView {
            if view.frame.width == width {
                view.removeFromSuperview()
            }
        }
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
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        [nameLabel, amountLabel].forEach { stackView.addArrangedSubview($0) }
        
        separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
