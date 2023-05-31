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
    @Environment(\.managedObjectContext) private var viewContext;
    @AppStorage("currentUser") private var currentUser = 666;
    
    @State var isLoading: Bool = true;
    @State var userDetails: UserDetailsResponse?;
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserEntity.username, ascending: true)],
        predicate: NSPredicate(format: "id == %ld", UserDefaults.standard.integer(forKey: "currentUser")),
        animation: .default)
    var users: FetchedResults<UserEntity>
    var body: some View {
        VStack {
            if (users.count == 0 ) {
                Text("User not found")
            } else {
                if isLoading {
                    ProgressView()
                } else {
                    VStack {
                        
                        // MARK: - Header
                        HStack {
                            AsyncImage(url: URL(string: userDetails?.user.avatar ??  "https://res.cloudinary.com/postman/image/upload/t_user_profile_300/v1/user/default-7")!, scale: 4)
                                .scaledToFill()
                            .frame(width: 100, height: 100)
                            
                            VStack {
                                Text(userDetails?.user.fullName ??  users[0].username ?? "")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                
                                HStack {
                                    Image(systemName: "mail")
                                        .foregroundColor(.accentColor)
                                    Text(userDetails?.user.email ?? "")
                                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                }
                                
                            }
                                
                        } //: HStack
                        .padding()
                        
                        // MARK: - BODY
                        Spacer()
                        VStack {
                            HStack {
                                Text("Your Api Key: ")
                                Text(users[0].apiKey ?? "No api key")
                                    .textSelection(.enabled)
                                    .lineLimit(1)
                            }
                            .padding()
                        
                            
                            
                            if let userOperations = userDetails?.operations {
                                ForEach(userOperations, id: \.self) { operation in
                                    
                                    ProgressView(operation.name.split(separator: "_").joined(separator: " ").capitalized, value: Double(operation.usage), total: Double(operation.limit))
                                        .padding()

                                    
                                }
                            }
                            
                            Spacer()

                                Button(action: {
                                    UserDefaults.standard.set(0, forKey: "currentUser");
                                }) {
                                    HStack {
                                        Image(systemName: "power")
                                        Text("Logout")
                                    }
                                }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                
                    do {
                        let apiKey = getApiKeyFor(userId: currentUser, context: viewContext)
                        let _userDetails = try await fetchUserDetailsWith(apiKey: apiKey)
                        isLoading = false;
                        userDetails = _userDetails
                    } catch {
                        print(error)
                    }
            }
        }
 
    }

}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        UserProfileView(name: "Pranav Singhal", hidePrimaryToolbar: .constant(false))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
