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
    
    var expandedView: some View {
        VStack {
            
            // MARK: - Header
            HStack {
                profileImage
                .matchedGeometryEffect(id: "image", in: profileAnimation)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isProfileExpanded.toggle()
                    }

                }
                    
                
                VStack {
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
            
            Spacer()

            Spacer()
            
        }
    }
    
    var collapsedView: some View {
        
        VStack {
            
            Text(name)
                .matchedGeometryEffect(id: profileName, in: profileAnimation)
                .font(.title)
                .fontWeight(.bold)

            profileImage
            .matchedGeometryEffect(id: "image", in: profileAnimation)
            .frame(width: imageDimension, height: imageDimension)
            .onTapGesture {
                withAnimation(.linear) {
                    isProfileExpanded.toggle()
                }
                
            }
        }
        
        
    }
    
    var profileImage: some View {
        AsyncImage(url: URL(string: "https://res.cloudinary.com/postman/image/upload/t_user_profile_300/v1/user/default-7")!, scale: 4){ image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
                
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(name: "Pranav Singhal")
    }
}
