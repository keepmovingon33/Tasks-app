//
//  OngoingTableViewControllers.swift
//  TasksApp
//
//  Created by sky on 12/20/21.
//

import UIKit
import Loaf

protocol OngoingTVCDelegate: AnyObject {
    func showOption(for task: Task)
}

class OngoingTableViewController: UITableViewController, Animatable {
    
    private let databaseManager = DatabaseManager()
    weak var delegate: OngoingTVCDelegate?
    
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
        databaseManager.addTasksListener(forDoneTasks: false) { [weak self] (result) in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription)
            }
        }
    }
    
    private func handleActionButton(for task: Task) {
        guard let id = task.id else { return }
        databaseManager.updateTasks(id: id, isDone: true) { [weak self] (result) in
            switch result {
            case .success:
                self?.showToast(state: .info, message: "Move to Done", duration: 2.0)
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription, duration: 2.0)
            }
        }
    }
}

extension OngoingTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? OngoingTaskTableViewCell else { return UITableViewCell() }
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButton(for: task)
            print("Hello")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // make the visual effect when select on the row
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        delegate?.showOption(for: task)
    }
}
