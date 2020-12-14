//
//  TableViewHeader.swift
//   Today's tasks
//
//  Created by Дарья on 10.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit

class TableViewHeader: UITableViewHeaderFooterView {

    let durationLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been emplemented")
    }

    fileprivate func configureView() {
        
        contentView.backgroundColor = .lightGray
        
        durationLabel.textColor = .white
        durationLabel.font = .boldSystemFont(ofSize: 20)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            durationLabel.heightAnchor.constraint(equalToConstant: 28),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 8),
            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
