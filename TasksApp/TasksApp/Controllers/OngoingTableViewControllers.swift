//
//  OngoingTableViewControllers.swift
//  TasksApp
//
//  Created by sky on 12/20/21.
//

import UIKit

class OngoingTableViewController: UITableViewController {
    
    private let databaseManager = DatabaseManager()
    
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make tableview rows in the footer disappeared
        tableView.tableFooterView = UIView()
        addTasksListener()
    }
    
    private func addTasksListener() {
        databaseManager.addTasksListener { [weak self] (result) in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleActionButton(for task: Task) {
        guard let id = task.id else { return }
        databaseManager.updateTasksToDone(id: id) { (result) in
            switch result {
            case .success:
                print("set to done successfully")
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension OngoingTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as? OngoingTaskTableViewCell else { return UITableViewCell() }
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButton(for: task)
            print("Hello")
        }
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // make the visual effect when select on the row
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}
