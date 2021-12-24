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
    @IBOutlet weak var deadlineLabel: UILabel!
    
    private var subscribers = Set<AnyCancellable>()
    @Published private var taskString: String?
    @Published private var deadline: Date?
    
    weak var delegate: TaskVCDelegate?
    
    private lazy var calendarView: CalendarView = {
        let view = CalendarView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // we need to calculate the height of the keyboard and then display the textfield above it. The way to calculate the keyboard height is using NotificationCenter.
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification: notification)
        containerViewBottomConstraint.constant = keyboardHeight - 200 - 8
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        containerViewBottomConstraint.constant = -containerView.frame.height
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
        
        $deadline.sink { (date) in
            self.deadlineLabel.text = date?.toString() ?? ""
        }.store(in: &subscribers)

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let taskString = self.taskString else { return }
        
        let task = Task(title: taskString, deadline: deadline)
        
        delegate?.didAddTask(task)
        dismiss(animated: true, completion: nil)
    }
    
    private func showCalendar() {
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        // tap on calendar, the keyboard will be dismissed
        taskTextField.resignFirstResponder()
        showCalendar()
    }
    
    private func dismissCalendarView(completion: () -> Void) {
        calendarView.removeFromSuperview()
        completion()
    }
    
}

extension NewTaskViewController: UIGestureRecognizerDelegate {
    // this func will handle which area will be considered as a touch. If that area is touchable, then
    // the func dismissViewController will be called. Otherwise, it will not handle the touch event.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if calendarView.isDescendant(of: view) {
            if touch.view?.isDescendant(of: calendarView) == false {
                dismissCalendarView { [weak self] in
                    self?.taskTextField.becomeFirstResponder()
                }
            }
            return false
        }
        return true
    }
}

extension NewTaskViewController: CalendarViewDelegate {
    func calendarViewDidRemoveButton() {
        dismissCalendarView { [unowned self] in
            self.taskTextField.becomeFirstResponder()
            self.deadline = nil
        }
    }
    
    func calendarViewDidSelectDate(date: Date) {
        dismissCalendarView { [unowned self] in
            self.taskTextField.becomeFirstResponder()
            self.deadline = date
        }
        
    }
}
