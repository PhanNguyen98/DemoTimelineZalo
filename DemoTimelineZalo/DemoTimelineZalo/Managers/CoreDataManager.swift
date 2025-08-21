//
//  CoreDataManager.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "DemoTimelineZalo")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Saved context")
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
