//
//  LoadingViewController.swift
//  TasksApp
//
//  Created by sky on 12/25/21.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showInitialScreen()
    }
    
    func showInitialScreen() {
        if authManager.isUserLoggedIn() {
            navigationManager.show(scene: .tasks)
        } else {
            navigationManager.show(scene: .onboarding)
        }
    }
}
