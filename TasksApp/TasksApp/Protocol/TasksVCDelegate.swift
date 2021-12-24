//
//  TasksVCDelegate.swift
//  TasksApp
//
//  Created by sky on 12/22/21.
//

import Foundation

protocol NewTaskVCDelegate: AnyObject {
    func didAddTask(_ task: Task)
    func didEditTask(_ task: Task)
}
