//
//  ActiveTasks
//  TaskApp
//
//  Created by Ion M on 6/30/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit
import Firebase

class ActiveTasks: UITableViewController {
    
    // MARK: Object instances
    
    var tasks: [Task] = []
    let ref = Database.database().reference(withPath: "active-tasks")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Attach a listener to receive updates whenever the tasks endpoint is modified
        ref.observe(.value) { snapshot in
            // Store the latest version of the data in a local variable inside the listener’s closure
            var newTaks: [Task] = []
            // The listener’s closure returns a snapshot of the latest set of data
            for child in snapshot.children {
                // The Task struct has an initializer that populates its properties using a DataSnapshot
                if let snapshot = child as? DataSnapshot,
                    let task = Task(snapshot: snapshot) {
                    newTaks.append(task)
                }
            }
            self.tasks = newTaks
            self.tableView.reloadData()
        }
    }
    
    // MARK:- TableView datat source and delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveCell", for: indexPath)
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        
        toggleCellCheckbox(cell, isCompleted: task.completed)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let newTask = self.tasks[indexPath.row]
        
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.updateAction(task: newTask, indexPath: indexPath)
        }
        
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            newTask.ref?.removeValue()
        }
        
        editButton.backgroundColor = UIColor.gray
        return [deleteButton, editButton]
    }
    
    private func updateAction(task: Task, indexPath: IndexPath) {
        //TASK: Build the update functionality here

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var task = tasks[indexPath.row]
        let toggledCompletion = !task.completed
        
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        task.completed = toggledCompletion
        tableView.reloadData()
    }
    
    // MARK:- Update cell UI
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
        }
    }
    
    // MARK:- Add Items
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Task", message: "Add a New Task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
            // Get the text field, and its text, from the alert controller
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            // Using the current user’s data, create a new, uuncompleted Task
            let task = Task(name: text, completed: false)
            // Create a child reference
            let taskRef = self.ref.child(text)
            // Use setValue(_:) to save data to the database. This method expects a Dictionary. Task has a helper function called toAnyObject() to turn it into a Dictionary
            taskRef.setValue(task.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

