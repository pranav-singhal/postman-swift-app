//
//  CreateNewWorkspaceButton.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 30/05/23.
//

import SwiftUI

struct CreateNewWorkspaceButton: View {
    @State private var showNewWorkspaceSheet: Bool = false;
    @Binding var showNewWorkspaceButton: Bool;
    var body: some View {
        Button(action: {
            
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
            CreateNewWorkspaceView(showNewWorkspaceSheet: $showNewWorkspaceSheet)
        }
        .opacity(showNewWorkspaceButton ? 1 : 0)
    }
}

struct CreateNewWorkspaceButton_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewWorkspaceButton(showNewWorkspaceButton: .constant(true))
    }
}
