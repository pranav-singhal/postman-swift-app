//
//  ContentView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 15/04/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            UserProfileView()
            .tabItem{
                    Image(systemName: "person.fill")
                    Text("Your Profile")
            }
            WorkspaceListView()
                .tabItem{
                    Image(systemName: "square.grid.2x2")
                    Text("Workspaces")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
