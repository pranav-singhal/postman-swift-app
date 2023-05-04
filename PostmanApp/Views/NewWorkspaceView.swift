//
//  NewWorkspaceView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 21/04/23.
//

import SwiftUI
import CoreData

struct NewWorkspaceView: View {
    
    @Environment(\.managedObjectContext) private var viewContext;
    @State var hidePrimaryToolbar: Bool;
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkspaceEntity.id, ascending: true)],
        predicate: NSPredicate(format: "owner.id == %ld", UserDefaults.standard.integer(forKey: "currentUser")),
        animation: .default)
    var workspaces: FetchedResults<WorkspaceEntity>
    
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.username)]
        ) var allUsers: FetchedResults<UserEntity>
    
    
    var body: some View {
        VStack {
            Button("delete current user") {
                UserDefaults.standard.set(0, forKey: "currentUser");
            }
            List {
                ForEach(workspaces) { workspace in

                    
                    HStack {
                        Text(workspace.owner?.apiKey ?? "")
                        Text(workspace.name ?? "")
                        Text(workspace.id ?? "")
                    }
                }
            }

            Button(action: {
                let newWorkspace = WorkspaceEntity(context: viewContext);
                newWorkspace.id = UUID().uuidString;
                newWorkspace.name = "random name first";
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }, label: {
                Text("press to add workspace")
            })
        }
        .onAppear{
            hidePrimaryToolbar = false
                }

    }
}

struct NewWorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewWorkspaceView(hidePrimaryToolbar: true)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
