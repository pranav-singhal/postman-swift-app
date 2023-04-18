//
//  WorkspaceListView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 16/04/23.
//

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

import SwiftUI

struct WorkspaceListView: View {
    
    @State private var workspaces: [Workspace] = [];

    @State private var isLoading: Bool = true;

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
                                Image(systemName: getIconFrom(workspaceType: workspace.type))
                                NavigationLink(destination: WorkspaceDetailsView(workspace: workspace)) {
                                    Text(workspace.name)
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                }
                            }
                        }
                    }
                    .navigationBarTitle("Your Workspaces", displayMode: .large)
                }
                }
                .opacity( isLoading ? 0 : 1)
        }
        .onAppear() {
            DispatchQueue.main.async {
                fetchWorkspacesWith() { response in
                    print(response.count)
                    self.workspaces = response;
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isLoading.toggle()
                    }
                    
                }
            }
            
            
        }
        .onDisappear(){
            self.isLoading.toggle()
        }
    }
        
}

struct WorkspaceListView_Previews: PreviewProvider {
    
 
    static var previews: some View {
        WorkspaceListView()
    }
}

// Now that you are confident about being able to make api calls, focus on design
// create a display with a list of workspaces
// link them to a page with the collections inside it
// workspace list can be basic
// each collection can be a card

// TODO : add a floating button for creating a new workspace
