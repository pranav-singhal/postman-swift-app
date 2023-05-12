//
//  UserProfileView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 17/04/23.
//

import SwiftUI

struct UserProfileView: View {
    @State private var isProfileExpanded: Bool = false;
    
    let name: String;
    @Binding var hidePrimaryToolbar: Bool;
    @Namespace private var profileAnimation;
    @Namespace private var profileName;
    let imageDimension: Double = 300
    var body: some View {
        VStack {
            if (isProfileExpanded) {
                expandedView
            } else {
                collapsedView
            }
        }
 
    }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserEntity.username, ascending: true)],
        predicate: NSPredicate(format: "id == %ld", UserDefaults.standard.integer(forKey: "currentUser")),
        animation: .default)
    var users: FetchedResults<UserEntity>
    
    
    
    
    var expandedView: some View {
        VStack {
            
            // MARK: - Header
            HStack {
                profileImage
                .matchedGeometryEffect(id: "image", in: profileAnimation)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.4)) {
                        isProfileExpanded.toggle()
                    }

                }
                    
                
                VStack {
                    Text(users[0].apiKey ?? "No api key")
                        .textSelection(.enabled)
                    Text(name)
                        .matchedGeometryEffect(id: profileName, in: profileAnimation)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    
                    HStack {
                        Image(systemName: "mail")
                            .foregroundColor(.accentColor)
                        Text("pranavsinghal96@gmail.com")
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    }
                    
                }
                    
            } //: HStack
            .padding()
            
            // MARK: - BODY
            Spacer()
            VStack {
                Text("Teams go here")
            }
            
            
        }
    }
    
    var collapsedView: some View {
        
        VStack {
            Button("delete current user") {
                UserDefaults.standard.set(0, forKey: "currentUser");
            }
            
            Text(name)
                .matchedGeometryEffect(id: profileName, in: profileAnimation)
                .font(.title)
                .fontWeight(.bold)

            profileImage
            .matchedGeometryEffect(id: "image", in: profileAnimation)
            .frame(width: imageDimension, height: imageDimension)
            .onTapGesture {
                withAnimation(.linear(duration: 0.4)) {
                    isProfileExpanded.toggle()
                }
                
            }
        }
        
        
    }
    
    var profileImage: some View {
        AsyncImage(url: URL(string: "https://res.cloudinary.com/postman/image/upload/t_user_profile_300/v1/user/default-7")!, scale: 4)
            .scaledToFill()
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        UserProfileView(name: "Pranav Singhal", hidePrimaryToolbar: .constant(false))
    }
}
