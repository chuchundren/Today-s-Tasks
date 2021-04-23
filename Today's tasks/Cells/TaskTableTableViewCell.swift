//
//  TaskTableTableViewCell.swift
//   Today's tasks
//
//  Created by Дарья on 27.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit

class TaskTableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
