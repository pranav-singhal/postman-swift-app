//
//  ContentView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 15/04/23.
//

import SwiftUI

struct ContentView: View {
    

    @AppStorage("currentUser") private var currentUser = 666;
    @State var hidePrimaryToolbar: Bool = false;
    


    var body: some View {
        if (currentUser == 0) {
            OnboardingView(apiKey: "")
                .transition(.opacity.animation(.easeInOut(duration: 0.5)))

        } else {
            TabView{
                
                UserProfileView(name: "Pranav Singhal", hidePrimaryToolbar: $hidePrimaryToolbar)
                    .onAppear{
                        
                        hidePrimaryToolbar = false
                    }
                .tabItem{
                        Image(systemName: "person.fill")
                        Text("Your Profile")
                }
                WorkspaceListView()
                    .tabItem{
                        Image(systemName: "square.grid.2x2")
                        Text("Workspaces")
                        
                    }
                
                NewWorkspaceView(hidePrimaryToolbar: hidePrimaryToolbar)
                .tabItem{
                        Image(systemName: "person.2.fill")
                        Text("Users")
                }
                    
            }
            
            .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
