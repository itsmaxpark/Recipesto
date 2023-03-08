//
//  RPTimeView.swift
//  Recipesto
//
//  Created by Max Park on 3/7/23.
//

import UIKit

class RPTimeView: UIView {
    
    var totalView: RPTimeLabel
    var cookView: RPTimeLabel
    var prepView: RPTimeLabel
    
    required init(totalTime: Int, cookTime: Int, prepTime: Int) {
        totalView = RPTimeLabel(type: .total, time: totalTime)
        cookView = RPTimeLabel(type: .cook, time: cookTime)
        prepView = RPTimeLabel(type: .prep, time: prepTime)
        super.init(frame: .zero)
        configureView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureUI() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        [totalView,cookView,prepView].forEach { stackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
    }
    
    
}
