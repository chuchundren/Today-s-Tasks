//
//  ExpandableTableViewHeader.swift
//   Today's tasks
//
//  Created by Дарья on 15.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit

protocol ExpandableTableViewHeaderDelegate {
    func toggleSection(header: ExpandableTableViewHeader, section: Int)
}

class ExpandableTableViewHeader: UITableViewHeaderFooterView {

    let titleLabel = UILabel()
    let arrow = UIImageView()
    
    var delegate: ExpandableTableViewHeaderDelegate?
    
    var section = 1
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been emplemented")
    }

    fileprivate func configureView() {
        
        contentView.backgroundColor = .white
        
        titleLabel.textColor = .systemBlue
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        arrow.image = UIImage.init(systemName: "arrowtriangle.down.fill")
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrow)
        
        NSLayoutConstraint.activate([
            arrow.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 0),
            arrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: arrow.layoutMarginsGuide.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(gestureRecognizer:))))
    }

    func rotateArrow(expanded: Bool) {
        arrow.rotate(to: expanded ? 0.0 : .pi / 2)
    }
    
    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? ExpandableTableViewHeader else {
            return
        }
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
}


extension UIView {
    func rotate(to value: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = value
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
}
