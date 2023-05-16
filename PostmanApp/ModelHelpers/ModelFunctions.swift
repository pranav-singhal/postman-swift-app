//
//  ModelFunctions.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 24/04/23.
//

import Foundation
import CoreData
import SwiftUI

func deleteEntitiesFromDatabase<T: NSManagedObject>(context: NSManagedObjectContext, entitiesToBeDeleted: [T]) -> Void {
    for _entitty in entitiesToBeDeleted {
        context.delete(_entitty)
    }
    
    try! context.save();
}



// MARK: -  Cleanup delted workspaces

func cleanupDeletedWorkspaces(context: NSManagedObjectContext, workspacesFromApi: [Workspace], userId: Int) -> Void {
    
    
    // MARK: -  1. Fetch workspaces stored in db
    
    let fetchRequestForWorkspaces = WorkspaceEntity.fetchRequest();
    fetchRequestForWorkspaces.predicate = NSPredicate(format: "owner.id == %ld", userId)
    let dbWorkspaces = try! context.fetch(fetchRequestForWorkspaces);
    let apiWorkspaceIds = workspacesFromApi.map { $0.id };
    let workspacesToRemove = dbWorkspaces.filter({_workspace in
        let _workspaceEntity = _workspace as WorkspaceEntity;

        if let _workspaceId = _workspaceEntity.id {
            return !apiWorkspaceIds.contains(_workspaceId);
        }
        return false;
    })

    deleteEntitiesFromDatabase(context: context, entitiesToBeDeleted: workspacesToRemove)
    
}


func cleanUpDeletedCollections(context: NSManagedObjectContext, collectionsFromApi: [Collection], workspaceId: String) -> Void {
    let fetchRequestForCollections = CollectionEntity.fetchRequest();
    fetchRequestForCollections.predicate = NSPredicate(format: "workspace.id == %@", workspaceId);
    let dbCollections = try! context.fetch(fetchRequestForCollections);
    let apiCollectionsIds = collectionsFromApi.map { $0.id };
    let collectionsToRemove = dbCollections.filter{ _collection in
        if let _collectionId = _collection.id {
            return !apiCollectionsIds.contains(_collectionId)
        }
        
        return false;
    }

    deleteEntitiesFromDatabase(context: context, entitiesToBeDeleted: collectionsToRemove)
}

func saveCollectionsFromApi(context: NSManagedObjectContext, workspaceId: String, collections: [Collection]) -> Void {
    let fetchRequest = WorkspaceEntity.fetchRequest();
    fetchRequest.predicate = NSPredicate(format: "id == %@", workspaceId);
    
    let workspaceResult = try! context.fetch(fetchRequest);
    
    if workspaceResult.count == 0 {
        fatalError("No workspace found for id: \(workspaceId)")
    }
    
    let fetchedWorkspace = workspaceResult[0];
    let dateFormatter = ISO8601DateFormatter();
    
    for collection in collections {
        let _fetchRequest: NSFetchRequest<CollectionEntity> = CollectionEntity.fetchRequest();
        
        _fetchRequest.predicate = NSPredicate(format: "id == %@", collection.id);
        
        let  result = try! context.fetch(_fetchRequest);
        if (result.count == 0) {
            // no collection found for this id, so store it in db
            let newCollection = CollectionEntity(context: context);
            newCollection.workspace = fetchedWorkspace;
            newCollection.name = collection.name
            newCollection.id = collection.id
            newCollection.uid = collection.uid
            
            
            newCollection.createdAt = dateFormatter.date(from: collection.createdAt)
            newCollection.updatedAt = dateFormatter.date(from: collection.updatedAt)
            
            if let forkCreatedAt = collection.fork?.createdAt {
                newCollection.forkFrom = collection.fork?.from
                newCollection.forkLabel = collection.fork?.label
                newCollection.forkCreatedAt = dateFormatter.date(from: forkCreatedAt)
            }
            
           
        } else {
            let existingCollection = result[0]; // assume result will only have one collection since we are fetching by colletion id
            existingCollection.name = collection.name;
            existingCollection.workspace = fetchedWorkspace;
        }
    }
    do {
        try context.save();
    } catch {
        let nsError = error as NSError;
        fatalError("Error storing collections with Error: \(nsError)");
    }
}

func saveWorkspacesFromApi(context: NSManagedObjectContext, workspaces: [Workspace], userId: Int ) -> Void {
    
    let fetchRequest = UserEntity.fetchRequest();
    fetchRequest.predicate = NSPredicate(format: "id == %ld", userId)
    
    let workspaceUserResult = try! context.fetch(fetchRequest);
    
    if workspaceUserResult.count == 0 {
        fatalError("No user found for the provided user ID, unable to save any workspaces");
    }
    
    let workspaceUser = workspaceUserResult[0];
    
    
    for workspace in workspaces {
        let _fetchRequest: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()

        _fetchRequest.predicate = NSPredicate(format: "id == %@", workspace.id)
        
        let result = try! context.fetch(_fetchRequest);
        if (result.count == 0) {
            // no workspace with this id found - so store it in db
            let newWorkspace = WorkspaceEntity(context: context);
            newWorkspace.id = workspace.id;
            newWorkspace.name = workspace.name;
            newWorkspace.type = workspace.type;
            newWorkspace.visibility = workspace.visibility;
            newWorkspace.owner = workspaceUser

            
        } else {
            // workspace found in db, lets update its properties
            let existintWorkspace = result[0]; // assume only one workspace will exist in result, since we are searching by ID
            existintWorkspace.name = workspace.name;
            existintWorkspace.type = workspace.type;
            existintWorkspace.visibility = workspace.visibility;
        }

    
    
    }
    if context.hasChanges {
                do {
                    try context.save();
                } catch {
                    let nsError = error as NSError;
                    fatalError("Error storing workspaces in db");
                }
    }
}

func createNewUserWith(context: NSManagedObjectContext, user: UserType, apiKey: String) -> Bool {
    let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest();
    
    fetchRequest.predicate = NSPredicate(format: "id == %ld", user.id)
    let result = try! context.fetch(fetchRequest);
    if result.count == 0 {
        let newUser = UserEntity(context: context);
        newUser.id = user.id;
        newUser.username = user.username;
        newUser.apiKey = apiKey;
        do {
            try context.save();
            return true;

        } catch {
            let nsError = error as NSError;
            fatalError("Error creating user with userId: \(user.id); error: \(nsError)");
        }
        
    }
    
    let existingUser = result[0];
    
    // update details of the user if they already exist in the system;

    existingUser.username = user.username;
    existingUser.apiKey = apiKey;
    
    do {
        try context.save();
        return true;

    } catch {
        let nsError = error as NSError;
        fatalError("Error updating user with userId: \(user.id); error: \(nsError)");
    }
    
}


func getApiKeyFor(userId: Int, context: NSManagedObjectContext) -> String {
    let fetchRequest = UserEntity.fetchRequest();
    fetchRequest.predicate = NSPredicate(format: "id == %ld", userId);
    let result = try! context.fetch(fetchRequest);
    if result.count == 0 {
        return "";
    }
    
    return result[0].apiKey ?? "";
}
