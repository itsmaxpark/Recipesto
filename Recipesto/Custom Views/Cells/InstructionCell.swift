//
//  InstructionCell.swift
//  Recipesto
//
//  Created by Max Park on 3/5/23.
//

import UIKit

class InstructionCell: UITableViewCell {
    static let identifier = "InstructionCell"
    
    let numberLabel = RPTitleLabel(textAlignment: .left, fontSize: 14)
    let instructionLabel = RPBodyLabel(textAlignment: .left, fontSize: 14)
    
    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func set(instruction: Instruction) {
        numberLabel.text = "\(instruction.position)"
        instructionLabel.text = instruction.displayText
    }
    
    func configure() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        [numberLabel, instructionLabel].forEach { stackView.addArrangedSubview($0) }
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
