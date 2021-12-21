//
//  MenuSection.swift
//  TasksApp
//
//  Created by sky on 12/20/21.
//

import Foundation

enum MenuSection: String, CaseIterable {
    // This enum conforms String so we could assign rawValue for each case as a String
    // This enum conforms CaseIterable so we could call allCases so it will return an array of all cases in this enum
    case ongoing = "Ongoing"
    case done = "Done"
}
