//
//  DataManager.swift
//   Today's tasks
//
//  Created by Дарья on 15.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation
import CoreData

struct CellData {
    var isExpanded: Bool
    var tasks: [Task]
}

var t: [CellData] = []
var today: [Task] = []
var thisWeek: [Task] = []
var thisMonth: [Task] = []
var completed: [Task] = []

class DataManager {
    
    var tasks: [Task] = []
    
    var sectionTitles = ["Today", "This week", "This month", "Completed tasks"]
    
    func arrayForSection() {
        let notCompleted = tasks.filter{($0.isCompleted == false)}
        
            today = notCompleted.filter({$0.duration == 0})
            let todayCell = CellData(isExpanded: true, tasks: today)
            t.append(todayCell)

            thisWeek = notCompleted.filter({$0.duration == 1})
            let thisWeekCell = CellData(isExpanded: true, tasks: thisWeek)
            t.append(thisWeekCell)

            thisMonth = notCompleted.filter({$0.duration == 2})
            let thisMonthCell = CellData(isExpanded: true, tasks: thisMonth)
            t.append(thisMonthCell)

            completed = tasks.filter({$0.isCompleted == true})
            let completedCell = CellData(isExpanded: true, tasks: completed)
            t.append(completedCell)
    
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
            
            arrayForSection()
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
    
    
    func save(_ title: String, duration: Int, managedContext: NSManagedObjectContext) {
        
        let task = Task(context: managedContext)
        task.title = title
        task.duration = Int16(duration)
        task.isCompleted = false
        
        do {
            try managedContext.save()
            
            switch task.duration {
            case 0:
                today.insert(task, at: 0)
            case 1:
                thisWeek.insert(task, at: 0)
            case 2:
                thisMonth.insert(task, at: 0)
            default:
                print("error: unknown duration: \(task.duration)")
            }

            print("success!! task is saved: \(task.title!)")
        
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }


}
