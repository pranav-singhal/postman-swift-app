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
    
// MARK: -  START: Properties
    @State private var isLoading: Bool = false;
    @State private var hidePrimaryToolbar: Bool = false;
    @State private var showNewWorkspaceSheet: Bool = false;
    @State private var showNewWorkspaceButton: Bool = true;
    @AppStorage("currentUser") private var currentUser = 666;
    
    @Environment(\.managedObjectContext) private var viewContext;
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkspaceEntity.name, ascending: true)],
        predicate: NSPredicate(format: "owner.id == %ld AND type == %@", UserDefaults.standard.integer(forKey: "currentUser"), "personal"),
        animation: .default)
    var personalWorkspaces: FetchedResults<WorkspaceEntity>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkspaceEntity.name, ascending: true)],
        predicate: NSPredicate(format: "owner.id == %ld AND type == %@", UserDefaults.standard.integer(forKey: "currentUser"), "team"),
        animation: .default)
    var teamWorkspaces: FetchedResults<WorkspaceEntity>
    
// MARK: -  END: Properties

    var body: some View {
        ZStack(alignment: .trailing) {
                ProgressView("Loading workspaces")
                    .progressViewStyle(.linear)
                    .padding()
                    .opacity( isLoading ? 1 : 0)

                VStack {

                    NavigationStack() {
                        
                        List {
                            Section("Personal") {
                                if (personalWorkspaces.count == 0) {
                                    Text("No personal workspaces")
                                } else {
                                    ForEach(personalWorkspaces) { workspace in
                                        WorkspaceListItem(hidePrimaryToolbar: $hidePrimaryToolbar, workspace: workspace)
                                        
                                    }.onDelete() { offsets in
                                        
                                        offsets.map { offset in
                                            return personalWorkspaces[offset]
                                        }.forEach { workspace in
                                            viewContext.delete(workspace)
                                        }
                                        try! viewContext.save()
                                    }
                                }
                            }
                            
                            Section("Team") {
                                if (teamWorkspaces.count == 0) {
                                    Text("No team workspaces")
                                } else {
                                    ForEach(teamWorkspaces) { workspace in
                                        WorkspaceListItem(hidePrimaryToolbar: $hidePrimaryToolbar,  workspace: workspace)
                                        
                                    }.onDelete() { offsets in
                                        
                                        offsets.map { offset in
                                            return teamWorkspaces[offset]
                                        }.forEach { workspace in
                                            viewContext.delete(workspace)
                                        }
                                        do {
                                            try viewContext.save()
                                        } catch {
                                            print("Unable to delete due to \(error)")
                                        }
                                    }
                                }
                            }
                        }
                        .onDisappear {
                            withAnimation(.spring()) {
                                            showNewWorkspaceButton = false
                        
                                        }
                        }
                        .onAppear {
                            withAnimation(.spring()) {
                                            showNewWorkspaceButton = true
                        
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
                        //                    .toolbarBackground(.red, for: .navigationBar)
                        //                    .toolbarBackground(.visible, for: .navigationBar)
                        
                    }
                }
                .opacity( isLoading ? 0 : 1)
            

                Button(action: {
                    print("I was clicked")
                    // TODO - add support for creating new workspace
                    self.showNewWorkspaceSheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
                .offset(x: -40, y: UIScreen.main.bounds.height/2 - 120)
                .sheet(isPresented: $showNewWorkspaceSheet) {
                    Text("Coming soon!")
                }
                .opacity(showNewWorkspaceButton ? 1 : 0)

            
            
        }
        .onAppear() {
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
        
        
        
        .toolbar(hidePrimaryToolbar ? .hidden : .visible, for: .tabBar)
        
    }
        
}

struct WorkspaceListView_Previews: PreviewProvider {
 
    static var previews: some View {
        WorkspaceListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

