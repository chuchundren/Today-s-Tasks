//
//  DataManager.swift
//   Today's tasks
//
//  Created by Дарья on 15.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation
import CoreData

class DataManager {

    func delete(_ object: Task, in managedContext: NSManagedObjectContext) {
        
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            print("deleting succeeded")
        } catch let error as NSError {
            print("could not delete: \(error)")
        }
    }
    
    
    func save(_ title: String, duration: Int, managedContext: NSManagedObjectContext) {
        
        let task = Task(context: managedContext)
        task.title = title
        task.duration = Int16(duration)
        task.isCompleted = false
        task.creationDate = Date()
        
        do {
            try managedContext.save()
            
            print("success!! task is saved: \(task.title!)")
            
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }
    
}

