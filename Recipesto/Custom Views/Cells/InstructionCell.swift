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
        selectionStyle = .none
        
        let cellView = UIView(frame: .zero)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(cellView)
        
        let containerView = UIView(frame: .zero)
        containerView.layer.cornerRadius = 6
        containerView.backgroundColor = .tertiarySystemBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(containerView)
        
        containerView.addSubviews(numberLabel, instructionLabel)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: padding),
            containerView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -4),
            
            numberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            numberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            numberLabel.heightAnchor.constraint(equalToConstant: 20),
            numberLabel.widthAnchor.constraint(equalToConstant: 20),
            
            instructionLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 8),
            instructionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            instructionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            instructionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
}
