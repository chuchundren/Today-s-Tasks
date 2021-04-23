//
//  TableViewController.swift
//  CoreData First Independent Try
//
//  Created by Дарья on 07/07/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    
   let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataManager = DataManager()
    var sectionExpandedInfo: [Bool] = []
    
    // MARK: - Fetched Results Controller

    private lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        //Sort Descriptors
        let durationSortDescriptor = NSSortDescriptor(key: #keyPath(Task.duration), ascending: true)
        //let completionSortDescriptor = NSSortDescriptor(key: #keyPath(Task.isCompleted), ascending: true)
        let dateSortDescriptor = NSSortDescriptor(key: #keyPath(Task.creationDate), ascending: false)
        
        // NSPredictate
        
        let predictate = NSPredicate(format: "isCompleted == false")
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [durationSortDescriptor, dateSortDescriptor]
        fetchRequest.predicate = predictate
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: "sectionIdentifier",
            cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTasks()
        
        for _ in fetchedResultsController.sections! {
            sectionExpandedInfo.append(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if let addVC = segue.destination as? AddViewController { }
    }
    
    private func fetchTasks() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    
    func editTaskAlert(at indexPath: IndexPath) {
        
        let task = fetchedResultsController.sections![indexPath.section].objects![indexPath.row] as! Task
        
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
    
    
    func deleteTask(in indexPath: IndexPath) {
        let task = fetchedResultsController.sections![indexPath.section].objects![indexPath.row] as! Task
        dataManager.delete(task, in: managedContext)
    }
    
    func completeTask(in indexPath: IndexPath) {
        let task = fetchedResultsController.sections![indexPath.section].objects![indexPath.row] as! Task
        task.isCompleted = true
        
        do {
            try self.managedContext.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sectionExpandedInfo[section] {
            let sectionInfo = self.fetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath) as? TaskTableTableViewCell else { fatalError("Could not dequeue cell")}
    
        configure(cell, at: indexPath)
        
        return cell
    }
    
    private func configure(_ cell: TaskTableTableViewCell, at indexPath: IndexPath) {
        let task = fetchedResultsController.object(at: indexPath)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.taskDescription
        cell.dateLabel.text = dateFormatter.string(from: task.creationDate!)
        cell.colorView.backgroundColor = UIColor.init(named: task.list!.color)
    }

    
    // MARK: - Edit table view
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { (action, view, _) in
            self.completeTask(in: indexPath)
        }
        completeAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, _) in
            self.deleteTask(in: indexPath)
        }
        if indexPath.section == 3 {
            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            return UISwipeActionsConfiguration(actions: [deleteAction, completeAction])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editTaskAlert(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? ExpandableTableViewHeader ?? ExpandableTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = fetchedResultsController.sections?[section].name
        header.rotateArrow(expanded: sectionExpandedInfo[section])
        header.section = section
        header.delegate = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}

//MARK: - NSFetchedResultsControllerDelegate

extension TasksTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                configure(cell as! TaskTableTableViewCell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        @unknown default:
            break
        }
    }
    
    // TODO: - deletion and insertion of sections
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            sectionExpandedInfo.insert(true, at: sectionIndex)
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            sectionExpandedInfo.remove(at: sectionIndex)
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            break
        }
    }
}



extension TasksTableViewController: ExpandableTableViewHeaderDelegate {
    func toggleSection(header: ExpandableTableViewHeader, section: Int) {
        let expanded = !sectionExpandedInfo[section]
        sectionExpandedInfo[section] = expanded
        
        header.rotateArrow(expanded: expanded)
        
        self.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}


