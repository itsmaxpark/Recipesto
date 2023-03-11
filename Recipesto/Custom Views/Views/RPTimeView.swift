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
    
    required init(totalTime: Int = 0, cookTime: Int = 0, prepTime: Int = 0) {
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
    
    func set(totalTime: Int, cookTime: Int, prepTime: Int) {
        totalView.timeLabel.text = "\(totalTime)"
        cookView.timeLabel.text = "\(cookTime)"
        prepView.timeLabel.text = "\(prepTime)"
    }
    
    private func configureView() {
        backgroundColor = .clear
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
