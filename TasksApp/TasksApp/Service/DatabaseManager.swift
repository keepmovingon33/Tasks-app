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
    
    func addTasksListener(completion: @escaping (Result<[Task], Error>) -> Void) {
        listener = tasksCollection.addSnapshotListener({ (snapshot, error) in
            
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
    
    func updateTasksToDone(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let fields: [String: Any] = ["isDone" : true, "doneAt" : Date()]
        tasksCollection.document(id).updateData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
