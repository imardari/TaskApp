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
    
    // MARK: Properties
    var tasks: [Task] = []
    
    let ref = Database.database().reference(withPath: "active-tasks")
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var task = tasks[indexPath.row]
        let toggledCompletion = !task.completed
        
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        task.completed = toggledCompletion
        tableView.reloadData()
    }
    
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
            // Grab whatever user typed in to the text field
            let textField = alert.textFields![0]
            // Assign that value as the task name
            let task = Task(name: textField.text!, completed: false)
            // Apend the task to the array of tasks
            self.tasks.append(task)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

