//
//  TableViewController.swift
//  CoreData First Independent Try
//
//  Created by Дарья on 07/07/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit
import CoreData

var tasks: [Task] = []
var t: [[Task]] = []

var today: [Task] = []
var thisWeek: [Task] = []
var thisMonth: [Task] = []
var completed: [Task] = []

class TableViewController: UITableViewController {
    
   let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        arrayForSection()
    }
    
    func arrayForSection() {
        let notCompleted = tasks.filter{($0.isCompleted == false)}
        
            today = notCompleted.filter({$0.duration == 0})
            t.append(today)

            thisWeek = notCompleted.filter({$0.duration == 1})
            t.append(thisWeek)

            thisMonth = notCompleted.filter({$0.duration == 2})
            t.append(thisMonth)

            completed = tasks.filter({$0.isCompleted == true})
            t.append(completed)
        
        tableView.reloadData()
    }
    
    //MARK: - CORE DATA

    func fetch() {
        
        do {
            /*
             // NSPredictate
            let requestToday = Task.fetchRequest() as NSFetchRequest<Task>
            let predictateToday = NSPredicate(format: "duration == 0")
            requestToday.predicate = predictateToday
             */
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            
            tasks = try managedContext.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            print("Fetching succeeded")
        } catch let error as NSError {
            print("could not fetch. \(error)")
        }
    }

    
    func delete(_ object: Task) {
    
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            print("deleting succeeded")
        } catch let error as NSError {
            print("could not delete: \(error)")
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return t.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TableViewHeader ?? TableViewHeader(reuseIdentifier: "header")
        switch section {
        case 0:
            header.durationLabel.text = "Today"
        case 1:
            header.durationLabel.text = "This week"
        case 2:
            header.durationLabel.text = "This month"
        case 3:
            header.durationLabel.text = "Completed Tasks"
        default:
            header.durationLabel.text = "nil"
        }
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch section {
        case 0:
            return today.count
        case 1:
            return thisWeek.count
        case 2:
            return thisMonth.count
        case 3:
            return completed.count
        default:
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
    
        
        switch indexPath.section {
        case 0:
            cell.taskTitleLabel.text = today[indexPath.row].title
        case 1:
            cell.taskTitleLabel.text = thisWeek[indexPath.row].title
        case 2:
            cell.taskTitleLabel.text = thisMonth[indexPath.row].title
        case 3:
            cell.taskTitleLabel.text = completed[indexPath.row].title
        default:
            cell.taskTitleLabel.text = "nil"
        }
        
        return cell
    }

    
    // MARK: - Edit table view
    
    func editTaskAlert(at indexPath: IndexPath, section: Int) {
        
        var task: Task!
        
        if section == 0 {
            task = today[indexPath.row]
        } else if section == 1 {
            task = thisWeek[indexPath.row]
        } else if section == 2 {
            task = thisMonth[indexPath.row]
        } else if section == 3 {
            return
        }
        
        let alert = UIAlertController(title: "Edit task", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = task.title
            textField.becomeFirstResponder()
        }
        
        let saveAction = UIAlertAction(title: "save", style: .default) { (saveAction) in
            
            let textfield = alert.textFields![0]
            guard textfield.text != nil && textfield.text != "" else { return }
            task.title = textfield.text
            
            do {
                try self.managedContext.save()
            } catch {
                print(error)
            }
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true) {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            editTaskAlert(at: indexPath, section: indexPath.section)
        case 1:
            editTaskAlert(at: indexPath, section: indexPath.section)
        case 2:
            editTaskAlert(at: indexPath, section: indexPath.section)
        default:
            return
        }
    }
    
    //MARK: - Delete rows
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
   
            if indexPath.section == 0 {
                let taskToDelete = today[indexPath.row]
                delete(taskToDelete)
                today.remove(at: indexPath.row)
                
            } else if indexPath.section == 1 {
                let taskToDelete = thisWeek[indexPath.row]
                delete(taskToDelete)
                thisWeek.remove(at: indexPath.row)
                
            } else if indexPath.section == 2 {
                let taskToDelete = thisMonth[indexPath.row]
                delete(taskToDelete)
                thisMonth.remove(at: indexPath.row)
                
            } else if indexPath.section == 3 {
                let taskToDelete = completed[indexPath.row]
                delete(taskToDelete)
                completed.remove(at: indexPath.row)
            }
            
            print("row: \(indexPath.row), section: \(indexPath.section)")
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddViewController {
            addVC.previousVC = self
        }
    }
    
}
