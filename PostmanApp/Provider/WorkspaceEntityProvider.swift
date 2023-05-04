//
//  Persistence.swift
//  Devote
//
//  Created by Pranav Singhal on 17/04/23.
//

import CoreData

class PersistenceController: ObservableObject {
    // MARK: 1 - Persistent Controller
    static let shared = PersistenceController()

    
    // MARK: 2 - Persistent Container
    let container: NSPersistentContainer

    // MARK: 3 - Initialisation ( load the persistnet store)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PostmanLocal")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: 4 - preview
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true);
        let viewContext = result.container.viewContext;
        let newUser = UserEntity(context: viewContext);
        newUser.id = 666;
        newUser.username = "cached user";
        newUser.apiKey = "random-api-key";
        try! viewContext.save()
        
            for i in 0..<5 {
                let newItem = WorkspaceEntity(context: viewContext)
                newItem.id = "\(i)"
                newItem.name = "Example workace: \(i)"
                newItem.visibility = "personal"
                newItem.type = "personal"
                newItem.owner = newUser;
            }
            do {
                try viewContext.save();
            } catch {

                let nsError = error as NSError;
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)");
            }
        return result;
        }()
}
