//
//  NavigationManager.swift
//  TasksApp
//
//  Created by sky on 12/24/21.
//

import UIKit

// this navigation manager is to transit user from any viewcontroller to any viewcontroller

class NavigationManager {
    
    static let shared = NavigationManager()
    
    private init() {}
    
    enum Scene {
        case onboarding
        case tasks
    }
    
    func show(scene: Scene) {
        
        var controller: UIViewController
        
        switch scene {
        case .onboarding:
            controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "OnboardingViewController")
        case .tasks:
            controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TaskNavigationController")
        }
        
        // now we will get window root viewcontroller and assign the root viewcontroller to this viewcontroller itself
        guard let windownScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windownScene.delegate as? SceneDelegate, let window = sceneDelegate.window else { return }
            
        // set rootViewController for TasksViewController
        window.rootViewController = controller
            
        // this line is optional. It is just visual effect
        UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: {}, completion: nil)
    }
}
