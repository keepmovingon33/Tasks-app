//
//  Extension+Date.swift
//  TasksApp
//
//  Created by sky on 12/23/21.
//

//https://nsdateformatter.com/

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        return formatter.string(from: self)
    }
}
