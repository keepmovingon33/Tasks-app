//
//  ViewController.swift
//  TasksApp
//
//  Created by sky on 12/19/21.
//

import UIKit

class TasksViewController: UIViewController, Animatable{

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ongoingViewController: UIView!
    @IBOutlet weak var doneViewController: UIView!
    
    private var databaseManager = DatabaseManager()
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSegmenedControl()
    }

    private func setupSegmenedControl() {
        // remove the default segments. we gonna insert new segments later
        menuSegmentedControl.removeAllSegments()
        
        MenuSection.allCases.enumerated().forEach { (index, section) in
            menuSegmentedControl.insertSegment(withTitle: section.rawValue, at: index, animated: false)
        }
        
        menuSegmentedControl.selectedSegmentIndex = 0
        showContainerView(.ongoing)
    }
    
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showContainerView(.ongoing)
        case 1:
            showContainerView(.done)
        default:
            break
        }
    }
    
    private func showContainerView(_ section: MenuSection) {
        switch section {
        case .ongoing:
            ongoingViewController.isHidden = false
            doneViewController.isHidden = true
        case .done:
            ongoingViewController.isHidden = true
            doneViewController.isHidden = false
        }
    }
    
    // pass data from child viewcontroller back to parent view through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTasksDetails",
           let destination = segue.destination as? NewTaskViewController {
            destination.delegate = self
        } else if segue.identifier == "showOngoingTask" {
            let destination = segue.destination as? OngoingTableViewController
            destination?.delegate = self
        } else if segue.identifier == "showEditTask",
                  let destination = segue.destination as? NewTaskViewController,
                  let taskToEdit = sender as? Task {
            destination.delegate = self
            destination.taskToEdit = taskToEdit
        }
    }
    
    private func editTask(task: Task) {
        performSegue(withIdentifier: "showEditTask", sender: task)
    }
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showTasksDetails", sender: nil)
    }
    
    private func deleteTask(id: String) {
        databaseManager.deleteTask(id: id) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription)
            case .success:
                self?.showToast(state: .info, message: "Delete task successfully!")
            }
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        showMenuOption()
    }
    
    private func showMenuOption() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logOutAction = UIAlertAction(title: "Logout", style: .default) { [unowned self] _ in
            self.logoutUser()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(logOutAction)
        present(alertController, animated: true, completion: nil)
    }

    private func logoutUser() {
        authManager.logout { (result) in
            switch result {
            case .success:
                navigationManager.show(scene: .onboarding)
            case .failure(let error):
                self.showToast(state: .error, message: error.localizedDescription)
            }
        }
    }
}

extension TasksViewController: NewTaskVCDelegate {
    func didAddTask(_ task: Task) {
        presentedViewController?.dismiss(animated: true, completion: { [unowned self] in
            self.databaseManager.addTask(task) { [weak self] (result) in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    self?.showToast(state: .error, message: error.localizedDescription)
                }
            }
        })
    }
    
    func didEditTask(_ task: Task) {
        presentedViewController?.dismiss(animated: true, completion: { [unowned self] in
            guard let id = task.id else { return }
            self.databaseManager.editTask(id: id, title: task.title, deadline: task.deadline) { [weak self] (result) in
                switch result {
                case .success:
                    self?.showToast(state: .info, message: "Updated successfully")
                case .failure(let error):
                    self?.showToast(state: .error, message: error.localizedDescription)
                }
            }
        })
    }
}

extension TasksViewController: OngoingTVCDelegate {
    func showOption(for task: Task) {
        let alertViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let id = task.id else { return }
            self?.deleteTask(id: id)
        }
        let editAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] _ in
            self.editTask(task: task)
        }
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(deleteAction)
        alertViewController.addAction(editAction)
        present(alertViewController, animated: true, completion: nil)
    }
}
