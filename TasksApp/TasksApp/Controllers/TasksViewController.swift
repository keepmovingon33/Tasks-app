//
//  ViewController.swift
//  TasksApp
//
//  Created by sky on 12/19/21.
//

import UIKit

class TasksViewController: UIViewController {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ongoingViewController: UIView!
    @IBOutlet weak var doneViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
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
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showTasksDetails", sender: nil)
    }

}

