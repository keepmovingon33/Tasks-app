//
//  DoneTableViewController.swift
//  TasksApp
//
//  Created by sky on 12/20/21.
//

import UIKit

class DoneTableViewController: UITableViewController, Animatable {
    
    private let databaseManager = DatabaseManager()
    private let authManager = AuthManager()
    
    private var doneTasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        addDoneTaskListener()
    }
    
    private func addDoneTaskListener() {
        guard let uid = authManager.getUserId() else {
            print("can't get uid")
            return
        }
        
        databaseManager.addTasksListener(forDoneTasks: true, uid: uid) { [weak self] (result) in
            switch result {
            case .success(let tasks):
                self?.doneTasks = tasks
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription)
            }
        }
    }
    
    private func handleActionButton(for task: Task) {
        guard let id = task.id else { return }
        databaseManager.updateTasks(id: id, isDone: false) { [weak self] (result) in
            switch result {
            case .success():
                self?.showToast(state: .info, message: "Move to Ongoing")
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription)
            }
        }
    }
}

extension DoneTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doneCellId", for: indexPath) as! DoneTasksTableViewCell
        let task = doneTasks[indexPath.row]
        cell.configure(with: task)
        cell.actionDidTapped = { [weak self] in
            self?.handleActionButton(for: task)
            print("handle for done")
        }
        return cell
    }
}
