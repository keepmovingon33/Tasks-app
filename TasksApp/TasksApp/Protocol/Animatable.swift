//
//  Animatable.swift
//  TasksApp
//
//  Created by sky on 12/23/21.
//

import Foundation
import Loaf
import MBProgressHUD

protocol Animatable {
    
}

// only a UIViewController could conform this protocol, so that it could use the func showinfoToast, because in this function, we have Loaf instance which require a UIViewcontroller for the sender, which we assign the the UIViewController itself
extension Animatable where Self: UIViewController {
    func showToast(state: Loaf.State, message: String, location: Loaf.Location = .top, duration: TimeInterval = 1.0) {
        // we use DispatchQueue here to move UI code to the main thread just in case we are calling the function in a callback of a background thread
        DispatchQueue.main.async {
            Loaf(message,
                 state: state,
                 location: location,
                 sender: self)
                .show(.custom(duration))
        }
    }
    
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3)
        }
    }
    
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
