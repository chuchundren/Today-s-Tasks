//
//  TableViewController.swift
//  CoreData First Independent Try
//
//  Created by Дарья on 07/07/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
   let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.fetch(from: managedContext)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }
    
    func editTaskAlert(at indexPath: IndexPath) {
        
        var task: Task!
        
        if indexPath.section == 0 {
            task = today[indexPath.row]
        } else if indexPath.section == 1 {
            task = thisWeek[indexPath.row]
        } else if indexPath.section == 2 {
            task = thisMonth[indexPath.row]
        } else if indexPath.section == 3 {
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
    
    
    func deleteTask(inSection section: Int, at row: Int) {
        switch section {
        case 0:
            let taskToDelete = today[row]
            dataManager.delete(taskToDelete, in: managedContext)
            today.remove(at: row)
        case 1:
            let taskToDelete = thisWeek[row]
            dataManager.delete(taskToDelete, in: managedContext)
            thisWeek.remove(at: row)
        case 2:
            let taskToDelete = thisMonth[row]
            dataManager.delete(taskToDelete, in: managedContext)
            thisMonth.remove(at: row)
        case 3:
            let taskToDelete = completed[row]
            dataManager.delete(taskToDelete, in: managedContext)
            completed.remove(at: row)
        default:
            return
        }
        print("row: \(row), section: \(section)")
        
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .fade)
        }, completion: nil)
    }
    
    func completeTask(inSection section: Int, at row: Int) {
        switch section {
        case 0:
            let taskToComplete = today[row]
            taskToComplete.isCompleted = true
            today.remove(at: row)
            completed.append(taskToComplete)
        case 1:
            let taskToComplete = thisWeek[row]
            taskToComplete.isCompleted = true
            thisWeek.remove(at: row)
            completed.append(taskToComplete)
        case 2:
            let taskToComplete = thisMonth[row]
            taskToComplete.isCompleted = true
            thisMonth.remove(at: row)
            completed.append(taskToComplete)
        default:
            return
        }
        
        do {
            try self.managedContext.save()
        } catch {
            print(error)
        }
    
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .fade)
            tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
        }, completion: nil)
    }
    
    // MARK: - Table view data source & delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return t.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? ExpandableTableViewHeader ?? ExpandableTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = dataManager.sectionTitles[section]
        header.rotateArrow(expanded: t[section].isExpanded)
        header.section = section
        header.delegate = self
        return header
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if t[section].isExpanded == true {
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
        } else {
            return 0
        }
    }
    
    // MARK: - Cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath)
    
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = today[indexPath.row].title
            cell.textLabel?.textColor = UIColor.black
        case 1:
            cell.textLabel?.text = thisWeek[indexPath.row].title
            cell.textLabel?.textColor = UIColor.black
        case 2:
            cell.textLabel?.text = thisMonth[indexPath.row].title
            cell.textLabel?.textColor = UIColor.black
        case 3:
            cell.textLabel?.text = completed[indexPath.row].title
            cell.textLabel?.textColor = UIColor.lightGray
        default:
            cell.textLabel?.text = "nil"
        }
        
        return cell
    }

    
    // MARK: - Edit table view
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            editTaskAlert(at: indexPath)
        case 1:
            editTaskAlert(at: indexPath)
        case 2:
            editTaskAlert(at: indexPath)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Deleting and completing
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { (action, view, _) in
            
            self.completeTask(inSection: indexPath.section, at: indexPath.row)
        
        }
        
        completeAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, _) in
            
            self.deleteTask(inSection: indexPath.section, at: indexPath.row)
            
        }
        
        if indexPath.section == 3 {
            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            return UISwipeActionsConfiguration(actions: [deleteAction, completeAction])
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddViewController {
           addVC.previousVC = self
        }
    }
    
}


extension TableViewController: ExpandableTableViewHeaderDelegate {
    func toggleSection(header: ExpandableTableViewHeader, section: Int) {
        let expanded = !t[section].isExpanded
        
        t[section].isExpanded = expanded
        header.rotateArrow(expanded: expanded)
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
