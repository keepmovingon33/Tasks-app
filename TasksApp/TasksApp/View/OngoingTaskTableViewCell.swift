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
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        actionButtonDidTap?()
    }
    
}
