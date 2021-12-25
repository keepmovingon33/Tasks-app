//
//  LoginViewController.swift
//  TasksApp
//
//  Created by sky on 12/24/21.
//

import UIKit
import Combine

class LoginViewController: UIViewController, Animatable {
    
    weak var delegate: LoginVCDelegate?
    
    private let authManager = AuthManager()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @Published var errorString: String = ""
    @Published var isLoginSuccessful = false
    
    private var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    private func observeForm() {
        $errorString.sink { [unowned self] (errorMessage) in
            self.errorLabel.text = errorMessage
        }.store(in: &subscribers)
        
        $isLoginSuccessful.sink { [unowned self] (isSuccessful) in
            if isSuccessful {
                self.delegate?.didLogin()
            }
        }.store(in: &subscribers)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            errorString = "Incomple form"
            return
        }
        errorString = ""
        showLoadingAnimation()
        
        authManager.login(withEmail: email, password: password) { [weak self] (result) in
            self?.hideLoadingAnimation()
            switch result {
            case .success:
                self?.isLoginSuccessful = true
            case .failure(let error):
                self?.errorLabel.text = error.localizedDescription
            }
        }
    }
    
    @IBAction func SignupButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            errorString = "Incomple form"
            return
        }
        
        showLoadingAnimation()
        
        authManager.signup(withEmail: email, password: password) { [weak self] (result) in
            self?.hideLoadingAnimation()
            
            switch result {
            case .success:
                self?.isLoginSuccessful = true
            case .failure(let error):
                self?.errorString = error.localizedDescription
            }
        }
    }
}

