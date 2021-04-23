//
//  Task Extension.swift
//   Today's tasks
//
//  Created by Дарья on 27.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation

extension Task {
    @objc func sectionIdentifier() -> String {
        switch duration {
        case 0:
            return "Today"
        case 1:
            return "This week"
        case 2:
            return "This month"
        default:
            fatalError("Unknown duration in section identifier")
        }
    }
}
