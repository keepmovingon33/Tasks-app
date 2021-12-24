//
//  DoneTasksTableViewCell.swift
//  TasksApp
//
//  Created by sky on 12/23/21.
//

import UIKit

class DoneTasksTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    var actionDidTapped: (() -> Void)?
    
    func configure(with task: Task) {
        titleLabel.text = task.title
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        actionDidTapped?()
    }
}
