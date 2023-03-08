//
//  RPTimeLabel.swift
//  Recipesto
//
//  Created by Max Park on 3/7/23.
//

import UIKit

class RPTimeLabel: UIView {
    
    enum TimeType {
        case total
        case cook
        case prep
    }
    
    var titleLabel = RPTitleLabel(textAlignment: .left, fontSize: 14)
    var timeLabel = RPBodyLabel(textAlignment: .left, fontSize: 14)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(type: TimeType, time: Int) {
        self.init(frame: .zero)
        set(type: type, time: time)
    }
    
    private func configureUI() {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        addSubviews(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        [titleLabel, timeLabel].forEach { stackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func set(type: TimeType, time: Int) {
        switch type {
        case .total:
            titleLabel.text = "Total Time"
        case .cook:
            titleLabel.text = "Cook Time"
        case .prep:
            titleLabel.text = "Prep Time"
        }
        timeLabel.text = "\(time) min"
    }
}
