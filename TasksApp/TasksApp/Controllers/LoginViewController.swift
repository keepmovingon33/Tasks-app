//
//  LoginViewController.swift
//  TasksApp
//
//  Created by sky on 12/24/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    weak var delegate: LoginVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        delegate?.didLogin()
    }
}
