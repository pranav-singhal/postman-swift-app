//
//  CollectionDetailsView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 15/05/23.
//

import SwiftUI

struct CollectionDetailsView: View {
    var collectionId: String
    @AppStorage("currentUser") private var currentUser = 666;
    
    @State var collectionItems: CollectionResponse.CollectionInfo?;
    
    @Environment(\.managedObjectContext) private var viewContext;
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "square.stack.fill")
                Text(collectionItems?.info.name ?? "")
                    .font(.title)
            }
            if let _collectionItems = collectionItems?.item {
                List {
                    ForEach(_collectionItems) { item in
                        if let _collectionFolder = item.item {
                            VStack {
                                NavigationLink(destination: CollectionFolder(folderItems: _collectionFolder)) {
                                    HStack {
                                        Image(systemName: "folder")
                                        Text(item.name ?? "folder")
                                    }
                                }

                                
                            }
                            
                            
                        } else {
                            if let itemRequest = item.request {
                                RequestListItem(request: itemRequest, name: item.name ?? "")
                            }
                        }
                        
                        
                    }
                }
                
            }
        }.onAppear{
            let apiKey = getApiKeyFor(userId: currentUser, context: viewContext)
            Task {
                do {
                    let collectionRequetsAndItems = try await fetchCollectionRequestsWith(apiKey: apiKey, collectionId: collectionId);
                    
                    collectionItems = collectionRequetsAndItems;
                } catch {
                    print("error: \(error)")
                }
                
            }
            
    }
    }
        
}

struct CollectionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionDetailsView(collectionId: "6a28a8a3-8a12-437a-a5b9-960a1891d814")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
