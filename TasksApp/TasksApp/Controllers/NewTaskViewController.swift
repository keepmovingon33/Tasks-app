//
//  NewTaskViewController.swift
//  TasksApp
//
//  Created by sky on 12/20/21.
//

import UIKit
import Combine

class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    private var subscribers = Set<AnyCancellable>()
    @Published private var taskString: String?
    
    weak var delegate: TaskVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .clear
//        backgroundView.backgroundColor = .clear
        
        // make the keyboard appeared
        taskTextField.becomeFirstResponder()
        
        observeForm()
        
        // When we tap on view, it will dismiss the viewcontroller and go back to TasksViewController
        setupGesture()
        
        // calculate the height of the keyboard
        observeKeyboard()
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // we need to calculate the height of the keyboard and then display the textfield above it. The way to calculate the keyboard height is using NotificationCenter.
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification: notification)
        containerViewBottomConstraint.constant = keyboardHeight - 200 - 8
        print("keyboardHeight: \(keyboardHeight)")
    }
    
    // calculate the height
    private func getKeyboardHeight(notification: Notification) -> CGFloat {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return 0 }
        return keyboardHeight
    }
    
    private func observeForm() {
        NotificationCenter.default.publisher(for:
            UITextField.textDidChangeNotification).map ({
                ($0.object as? UITextField)?.text
        }).sink { [unowned self] (text) in
            self.taskString = text
        }.store(in: &subscribers)
        
        $taskString.sink { [unowned self] (text) in
            self.saveButton.isEnabled = text?.isEmpty == false
        }.store(in: &subscribers)

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let taskString = self.taskString else { return }
        
        let task = Task(title: taskString)
        
        delegate?.didAddTask(task)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
    }
    
}
