//
//  Task.swift
//  TasksApp
//
//  Created by sky on 12/21/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Task: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Date?
    let title: String
    var isDone: Bool = false
    var doneAt: Date?
    var deadline: Date?
}
