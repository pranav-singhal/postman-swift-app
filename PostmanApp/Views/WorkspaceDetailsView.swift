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
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                hidePrimaryToolbar = true;
            }
            }
        
        
    }
    
        
}


struct WorkspaceDetailsView_Previews: PreviewProvider {

    static var previews: some View {


        WorkspaceDetailsView(workspace: WorkspaceEntity.example, hidePrimaryToolbar: .constant(false))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
}
