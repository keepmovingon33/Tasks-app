//
//  OngoingTaskTableViewCell.swift
//  TasksApp
//
//  Created by sky on 12/22/21.
//

import UIKit

class OngoingTaskTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var taskButton: UIButton!
    
    var actionButtonDidTap: (() -> Void)?
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        dueLabel.text = task.deadline?.toRelativeString()
        
        if task.deadline?.isOverDue() == true {
            dueLabel.textColor = .red
            dueLabel.font = UIFont(name: "AvenirNext-Medium", size: 12)
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        actionButtonDidTap?()
    }
    
}
