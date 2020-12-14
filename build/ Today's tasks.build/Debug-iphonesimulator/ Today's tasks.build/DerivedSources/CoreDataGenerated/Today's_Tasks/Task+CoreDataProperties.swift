//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Дарья on 14.12.2020.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var duration: Int16
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?

}

extension Task : Identifiable {

}
