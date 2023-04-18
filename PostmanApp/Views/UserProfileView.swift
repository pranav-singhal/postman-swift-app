//
//  UserProfileView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 17/04/23.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        VStack {
            
            // MARK: - Header
            HStack {
                AsyncImage(url: URL(string: "https://res.cloudinary.com/postman/image/upload/t_user_profile_300/v1/user/default-7")!, scale: 4){ image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                        
                }
                .frame(width: 100, height: 100)
                    
                
                VStack {
                    Text("Pranav Singhal")
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
            
            
            
            Spacer()
            
        }
        
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
