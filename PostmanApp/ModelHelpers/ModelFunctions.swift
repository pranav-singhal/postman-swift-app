//
//  ModelFunctions.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 24/04/23.
//

import Foundation
import CoreData
import SwiftUI

// MARK: -  Delte workspaces from database

func deleteWorkspacesFromDatabase(context: NSManagedObjectContext, workspacesToBeDeleted: [WorkspaceEntity]) -> Void {
    for _workspace in workspacesToBeDeleted {
        context.delete(_workspace);
    }
    try? context.save();
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
    
    deleteWorkspacesFromDatabase(context: context, workspacesToBeDeleted: workspacesToRemove);
    
}

func saveWorkspacesFromApi(context: NSManagedObjectContext, workspaces: [Workspace], userId: Int ) -> Void {
    // TODO - handle deleted workspaces;
    
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
            
            do {
                try context.save();
            } catch {
                let nsError = error as NSError;
                fatalError("Error storing workspace with id: \(workspace.id) with error: \(nsError)");
            }
            
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
            fatalError("Error creating user with userId: \(user.id)");
        }
        
    }
    
    let existingUser = result[0];
    
    // update details of the user if they already exist in the system;
    print("existing user found")
    existingUser.username = user.username;
    existingUser.apiKey = apiKey;
    
    do {
        try context.save();
        return true;

    } catch {
        let nsError = error as NSError;
        fatalError("Error updating user with userId: \(user.id)");
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
