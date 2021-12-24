//
//  CalendarViewDelegate.swift
//  TasksApp
//
//  Created by sky on 12/23/21.
//

import Foundation

protocol CalendarViewDelegate: AnyObject {
    func calendarViewDidSelectDate(date: Date)
    func calendarViewDidRemoveButton()
}
