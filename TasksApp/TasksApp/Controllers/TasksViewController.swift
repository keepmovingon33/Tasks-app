//
//  ViewController.swift
//  TasksApp
//
//  Created by sky on 12/19/21.
//

import UIKit
import Loaf

class TasksViewController: UIViewController, Animatable{

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ongoingViewController: UIView!
    @IBOutlet weak var doneViewController: UIView!
    
    private var databaseManager = DatabaseManager()
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTasksDetails",
           let destination = segue.destination as? NewTaskViewController {
            destination.delegate = self
        } else if segue.identifier == "showOngoingTask" {
            let destination = segue.destination as? OngoingTableViewController
            destination?.delegate = self
        }
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

}

extension TasksViewController: TaskVCDelegate {
    func didAddTask(_ task: Task) {
        databaseManager.addTask(task) { (result) in
            switch result {
            case .success:
                print("yay")
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
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
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(deleteAction)
        present(alertViewController, animated: true, completion: nil)
    }
}
