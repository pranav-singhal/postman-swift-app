import CoreData
import Foundation


extension WorkspaceEntity {
    
    // Example Workspace for Xcode previews
    static var example: WorkspaceEntity {
        
        // Get the first Workspace from the in-memory Core Data store
        let context = PersistenceController.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try? context.fetch(fetchRequest)
        
        return (results?.first!)!
    }
    
}
