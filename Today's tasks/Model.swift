//
//  Model.swift
//   Today's tasks
//
//  Created by Дарья on 15.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation
import CoreData

var t: [[Task]] = []
var today: [Task] = []
var thisWeek: [Task] = []
var thisMonth: [Task] = []
var completed: [Task] = []

class Model {
    
    var tasks: [Task] = []
    
    var sectionTitles = ["Today", "This week", "This month", "Completed tasks"]
    
    func arrayForSection(completion: (Bool) -> Void) {
        let notCompleted = tasks.filter{($0.isCompleted == false)}
        
            today = notCompleted.filter({$0.duration == 0})
            t.append(today)

            thisWeek = notCompleted.filter({$0.duration == 1})
            t.append(thisWeek)

            thisMonth = notCompleted.filter({$0.duration == 2})
            t.append(thisMonth)

            completed = tasks.filter({$0.isCompleted == true})
            t.append(completed)
    
        completion(true)
    }
    
    func fetch(from managedContext: NSManagedObjectContext) {
        
        do {
            /*
             // NSPredictate
            let requestToday = Task.fetchRequest() as NSFetchRequest<Task>
            let predictateToday = NSPredicate(format: "duration == 0")
            requestToday.predicate = predictateToday
             */
            
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            
            tasks = try managedContext.fetch(request)
            
            print("Fetching succeeded")
        } catch let error as NSError {
            print("could not fetch. \(error)")
        }
    }
    
    
    func delete(_ object: Task, in managedContext: NSManagedObjectContext) {
    
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            print("deleting succeeded")
        } catch let error as NSError {
            print("could not delete: \(error)")
        }
    }
    
    
    func save(_ title: String, duration: Int, managedContext: NSManagedObjectContext, completion: (Bool) -> ()) {
        
        let task = Task(context: managedContext)
        task.title = title
        task.duration = Int16(duration)
        task.isCompleted = false
        
        do {
            try managedContext.save()
            
            tasks.append(task)
//            switch task.duration {
//            case 0:
//                today.append(task)
//            case 1:
//                thisWeek.append(task)
//            case 2:
//                thisMonth.append(task)
//            default:
//                print("error: unknown duration: \(task.duration)")
//            }
            print("success!! task is saved: \(String(describing: task.title))")
            
            completion(true)
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }


}
