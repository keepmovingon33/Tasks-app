//
//  DatabaseManager.swift
//  TasksApp
//
//  Created by sky on 12/21/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class DatabaseManager {
    private let db = Firestore.firestore()
    private lazy var tasksCollection = db.collection("tasks")
    // ListenerRegistration is a protocol of FirebaseFirestores
    private var listener: ListenerRegistration?
    
    func addTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try tasksCollection.addDocument(from: task, completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            })
            
        } catch (let error) {
            completion(.failure(error))
        }
    }
    
    func addTasksListener(forDoneTasks isDone: Bool, completion: @escaping (Result<[Task], Error>) -> Void) {
        listener = tasksCollection
            .whereField("isDone", isEqualTo: isDone)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener({ (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
//                var tasks = [Task]()
//                snapshot?.documents.forEach({ (document) in
//                    if let task = try? document.data(as: Task.self) {
//                        tasks.append(task)
//                    }
//                })
                
                // refactor code
                var tasks = [Task]()
                do {
                    tasks = try snapshot?.documents.compactMap({
                        return try $0.data(as: Task.self)
                    }) ?? []
                } catch(let error) {
                    completion(.failure(error))
                }
                
                completion(.success(tasks))
            }
        })
    }
    
    func updateTasks(id: String, isDone: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        var fields: [String: Any] = [:]
        if isDone {
            fields = ["isDone": true, "doneAt": Date()]
        } else {
            fields = ["isDone": false, "doneAt": FieldValue.delete()]
        }
        tasksCollection.document(id).updateData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteTask(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        tasksCollection.document(id).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func editTask(id: String, title: String, deadline: Date?, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = ["title": title, "deadline": deadline as Any]
        
        tasksCollection.document(id).updateData(data) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
