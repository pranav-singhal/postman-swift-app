//
//  WorkspaceDetailsView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 17/04/23.
//

import SwiftUI

struct WorkspaceDetailsView: View {
    let workspace: Workspace;
    var body: some View {
        Text(workspace.name)
    }
}

struct WorkspaceDetailsView_Previews: PreviewProvider {
    
    static let workspace: Workspace = Workspace(id: "EPI~f4bc5679-7d5d-459a-9458-f53c948caf4d", name: "EPI workspace", type: "team", visibility: "personal")
    static var previews: some View {
        WorkspaceDetailsView(workspace: workspace)
    }
}
