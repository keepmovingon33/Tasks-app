//
//  OnboardingViewController.swift
//  TasksApp
//
//  Created by sky on 12/24/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let navigationManager = NavigationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoginScreen", let destination = segue.destination as? LoginViewController {
            destination.delegate = self
        }
    }
    
    @IBAction func startedButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showLoginScreen", sender: nil)
    }
}

extension OnboardingViewController: LoginVCDelegate {
    func didLogin() {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.navigationManager.show(scene: .tasks)
            print("dismiss View Controller")
        })
    }
}


