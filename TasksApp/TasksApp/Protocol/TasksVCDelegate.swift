//
//  TasksVCDelegate.swift
//  TasksApp
//
//  Created by sky on 12/22/21.
//

import Foundation

protocol TaskVCDelegate: AnyObject {
    func didAddTask(_ task: Task)
}
