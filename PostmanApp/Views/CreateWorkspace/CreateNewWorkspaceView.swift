//
//  CreateNewWorkspaceView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 30/05/23.
//

import SwiftUI

struct CreateNewWorkspaceView: View {
    @State private var workspaceName: String = "";
    @State private var workspaceDescription: String = "";
    @State private var workspaceType: String = "personal";
    @State private var showErrorAlert: Bool = false;
    @Binding var showNewWorkspaceSheet: Bool;
    @AppStorage("currentUser") private var currentUser = 666;
    
    @Environment(\.managedObjectContext) private var viewContext;
    
    var body: some View {
        VStack {
            Text("Create new workspace")
                .font(.title)

            Form{
                TextField("Name", text: $workspaceName)
                
                
                TextField("Description", text: $workspaceDescription, axis: .vertical)
                
                    .lineLimit(5...10)
                    
                
                Picker("Type", selection: $workspaceType) {
                    Text("Personal").tag("personal")
                    Text("Team").tag("team")
                }
                Section {
                    Button("Create new Workspace") {
                        Task {
                            do {
                                let apiKey = getApiKeyFor(userId: currentUser, context: viewContext);
                                
                                let newWorkspace = try await createNewWorkspace(apiKey: apiKey, name: workspaceName, description: workspaceDescription, type: workspaceType)
                                saveWorkspacesFromApi(context: viewContext, workspaces: [
                                    Workspace(id: newWorkspace.workspace.id, name: newWorkspace.workspace.name, type: workspaceType, visibility: workspaceType)
                                ], userId: currentUser)

                                showNewWorkspaceSheet.toggle()
                                
                            } catch {
                                if (workspaceType == "team") {
                                    showErrorAlert = true
                                }
                            }
                        }
                    }
                    .disabled(workspaceName == "")
                    .alert("Unable to create workspace. Try Changing its type", isPresented: $showErrorAlert) {
                        Button("OK", role: .cancel) {
                            showErrorAlert.toggle()
                        }
                    }
                }
            }
            
            
         
        }
        
        
    }
}

struct CreateNewWorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewWorkspaceView(showNewWorkspaceSheet: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
