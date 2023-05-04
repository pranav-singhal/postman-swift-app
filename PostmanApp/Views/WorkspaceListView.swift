//
//  WorkspaceListView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 16/04/23.
//
import SwiftUI
import CoreData

// MARK: -  Helper functions

func getIconFrom(workspaceType: String ) -> (String) {
    switch workspaceType {
    case "personal":
        return "person"
    case "team":
        return "person.2"
    default:
        return "globe"
    }
}

func refreshLocalStorage(context: NSManagedObjectContext, workspaces: [Workspace], userId: Int) {
    saveWorkspacesFromApi(context: context, workspaces: workspaces, userId: userId);
    cleanupDeletedWorkspaces(context: context, workspacesFromApi: workspaces, userId: userId);
}

// MARK: -  END: Helper functions



struct WorkspaceListView: View {
    

    @State private var isLoading: Bool = false;
    @State private var hidePrimaryToolbar: Bool = false;
    @AppStorage("currentUser") private var currentUser = 0;
    
    @Environment(\.managedObjectContext) private var viewContext;
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkspaceEntity.name, ascending: true)],
        predicate: NSPredicate(format: "owner.id == %ld", UserDefaults.standard.integer(forKey: "currentUser")),
        animation: .default)
    var workspaces: FetchedResults<WorkspaceEntity>

    var body: some View {
        ZStack {
                ProgressView("Loading workspaces")
                    .progressViewStyle(.linear)
                    .padding()
                    .opacity( isLoading ? 1 : 0)

                VStack {

                NavigationView() {
                
                    List {
                        ForEach(workspaces) { workspace in
                            HStack {
                                Image(systemName: getIconFrom(workspaceType: workspace.type ?? ""))
                                NavigationLink(destination: WorkspaceDetailsView(workspace: workspace, hidePrimaryToolbar: $hidePrimaryToolbar)) {

                                    Text(workspace.name ?? "un named workspace")
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                        
                                }
                            }
                            
                            .onAppear {
                                withAnimation(.spring()) {
                                    hidePrimaryToolbar = false
                                }
                            }
                            .toolbar(hidePrimaryToolbar ? .hidden : .visible, for: .tabBar)
                            
                        }.onDelete() { offsets in

                            offsets.map { offset in
                                return workspaces[offset]
                            }.forEach { workspace in
                                viewContext.delete(workspace)
                            }
                            try! viewContext.save()
                        }
                    }
                    .refreshable {
                        let apiKey = getApiKeyFor(userId: currentUser, context: viewContext)

                            do {
                                let workspacesResponse = try await fetchWorkspacesWith(apiKey);
                                refreshLocalStorage(context: viewContext, workspaces: workspacesResponse, userId: currentUser)
                            } catch {
                                print("Error fetching workspaces \(error)");
                            }
                    }
                    
                    .navigationTitle("Your Workspaces")
                }
                
                }
                
                .opacity( isLoading ? 0 : 1)
        }
        .onAppear() {
            
            hidePrimaryToolbar = false;
            let apiKey = getApiKeyFor(userId: currentUser, context: viewContext)
            Task {
                do {
                    let workspacesResponse = try await fetchWorkspacesWith(apiKey);
                    refreshLocalStorage(context: viewContext, workspaces: workspacesResponse, userId: currentUser);

                } catch {
                    print("Error fetching workspaces \(error)");
                }
            }

        }

    }
}

struct WorkspaceListView_Previews: PreviewProvider {
 
    static var previews: some View {
        WorkspaceListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

// TODO : add a floating button for creating a new workspace
