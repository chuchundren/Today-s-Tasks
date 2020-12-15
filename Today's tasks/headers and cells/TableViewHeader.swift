//
//  TableViewHeader.swift
//   Today's tasks
//
//  Created by Дарья on 10.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit

class TableViewHeader: UITableViewHeaderFooterView {

    let titleLabel = UILabel()
    
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
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}

