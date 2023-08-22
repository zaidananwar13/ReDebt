//
//  PersistenceController.swift
//  uTang
//
//  Created by Fuad Fadlila Surenggana on 08/04/23.
//


import CoreData
import Foundation

struct PersistenceController {
    let container: NSPersistentContainer
    static let shared = PersistenceController()

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        shared.saveContext()
        return result
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Hutang")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
//                fatalError("Error: \(error.localizedDescription)")
                assertionFailure("Error: \(error.localizedDescription)")
            }
        }
    }
}
