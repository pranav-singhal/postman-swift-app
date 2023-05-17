//
//  CollectionListView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 24/04/23.
//

import SwiftUI
import CoreData

func refreshLocalStorage(context: NSManagedObjectContext, collections: [Collection], workspaceId: String) {
    saveCollectionsFromApi(context: context, workspaceId: workspaceId, collections: collections)
    cleanUpDeletedCollections(context: context, collectionsFromApi: collections, workspaceId: workspaceId)
}


struct CollectionListView: View {
    @AppStorage("currentUser") private var currentUser = 666;
    
    @Environment(\.managedObjectContext) private var viewContext;
    @State private var workspaceId: String?;
    @State private var isLoading: Bool = true;

    @FetchRequest
    var workspaceCollections: FetchedResults<CollectionEntity>
    
    init(workspaceId: String){
        let request = CollectionEntity.fetchRequest();
        self._workspaceId = State(initialValue: workspaceId)
        request.sortDescriptors = [
                    NSSortDescriptor(keyPath: \CollectionEntity.name, ascending: true)
                ]
        request.predicate = NSPredicate(format: "workspace.id == %@", workspaceId)
        self._workspaceCollections = FetchRequest<CollectionEntity>(fetchRequest: request, animation: .spring());
    }
        

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Collections")
                    
            } else {
                
                    VStack {
                        if (workspaceCollections.count == 0) {
                            
                            Image(systemName: "shippingbox")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .padding()
                                .foregroundColor(.accentColor)
                                
                            Text("No collections")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                            Text("You don't seem to have any collections in this workspace")
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Button(action: {
                                let apiKey = getApiKeyFor(userId: currentUser, context: viewContext)
                                if let workspaceId = workspaceId {
                                    Task {
                                        do {
                                            let collectionListReponse = try await fetchCollectionsFor(workspaceId: workspaceId, apiKey: apiKey);
                                            refreshLocalStorage(context: viewContext, collections: collectionListReponse, workspaceId: workspaceId);
                                        } catch {
                                            print("Error fetching workspaces \(error)");
                                        }
                                    }
                                }
                            }){
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 30)
                            }
                            .padding()
                            
                        } else {
                            
                            NavigationStack {
                                List {
                                    Section("Your Collections:") {
                                        
                                        ForEach(workspaceCollections) {
                                            collection in
                                            HStack {
                                                Image(systemName: "square.stack.fill")
                                                NavigationLink(destination: CollectionDetailsView(collectionId: collection.id ?? "")) {
                                                        Text(collection.name ?? "")
                                                        .font(.title2)
                                                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        .onDelete { offsets in
                                            offsets.map{ offset in
                                                return workspaceCollections[offset]
                                            }.forEach{ collection in
                                                viewContext.delete(collection)
                                            }
                                            try! viewContext.save()
                                        }
                                    }
                                    
                                }
                                
                                .refreshable {
                                    let apiKey = getApiKeyFor(userId: currentUser, context: viewContext)
                                    if let workspaceId = workspaceId {
                                        Task {
                                            do {
                                                let collectionListReponse = try await fetchCollectionsFor(workspaceId: workspaceId, apiKey: apiKey);
                                                refreshLocalStorage(context: viewContext, collections: collectionListReponse, workspaceId: workspaceId)
                                                
                                                isLoading = false

                                            } catch {
                                                print("Error fetching workspaces \(error)");
                                                isLoading = false
                                            }
                                            
                                        }
                                    }
                            }
                            }
                        }
                    }
                    
            }
        }.onAppear {
            let apiKey = getApiKeyFor(userId: currentUser, context: viewContext);
            if let workspaceId = workspaceId {
                Task {
                    do {
                        let collectionListReponse = try await fetchCollectionsFor(workspaceId: workspaceId, apiKey: apiKey);
                        refreshLocalStorage(context: viewContext, collections: collectionListReponse, workspaceId: workspaceId);
                        isLoading = false
                    } catch {
                        print("Error fetching workspaces \(error)");
                        isLoading = false
                    }
                }
            }
    }
    }
}

struct CollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionListView(workspaceId: "1")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
