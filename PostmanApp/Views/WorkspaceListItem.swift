//
//  WorkspaceListItem.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 05/05/23.
//

import SwiftUI

struct WorkspaceListItem: View {

    @Binding var hidePrimaryToolbar: Bool;

    @ObservedObject var workspace: WorkspaceEntity;

    var body: some View {
        HStack {
            Image(systemName: getIconFrom(workspaceType: workspace.visibility ?? ""))
            NavigationLink(destination: WorkspaceDetailsView(workspace: workspace, hidePrimaryToolbar: $hidePrimaryToolbar)) {

                Text(workspace.name ?? "un named workspace")
                    .font(.title2)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    
            }
        }        .onAppear {
            withAnimation(.spring()) {
                hidePrimaryToolbar = false
            }
        }
        .toolbar(hidePrimaryToolbar ? .hidden : .visible, for: .tabBar)
    }
}

struct WorkspaceListItem_Previews: PreviewProvider {
    static var previews: some View {

        WorkspaceListItem(hidePrimaryToolbar: .constant(true), workspace: WorkspaceEntity.example)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
