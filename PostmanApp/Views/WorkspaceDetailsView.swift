//
//  WorkspaceDetailsView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 17/04/23.
//

import SwiftUI

struct WorkspaceDetailsView: View {
    
//    @Environment(\.managedObjectContext) var viewContext;
    @ObservedObject var workspace: WorkspaceEntity;
    @Binding var hidePrimaryToolbar: Bool;
    var body: some View {
        VStack {
            Text(workspace.name ?? "No name workspace")
                            .font(.title)
                            .toolbarBackground(.orange, for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
            
      
//                .font(.system(size: 10))
            TabView{
                        ApiListView()
                        .tabItem{
                                Image(systemName: "network")
                                Text("APIs")
                        }
                        CollectionListView()
                        .tabItem{
                                Image(systemName: "folder")
                                Text("Collections")
                        }
                        
                    }
            
            
            .onAppear {
                withAnimation(.spring()) {
                    hidePrimaryToolbar = true;
                }
                
            }
            }
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
        
}


struct WorkspaceDetailsView_Previews: PreviewProvider {

    static var previews: some View {


        WorkspaceDetailsView(workspace: WorkspaceEntity.example, hidePrimaryToolbar: .constant(false))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
}

// TODO - replace apilist view with environments list view

// TODO - add ability to fetch all collections
// add ability to run a request with a specific environment
// add ability to add new requests to  a collection
// add ability to update a collection / request inside a collection
