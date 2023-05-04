//
//  OnboardingView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 26/04/23.
//

import SwiftUI

struct OnboardingView: View {
    @State var apiKey: String = "";
    @State private var isAnimating = false;
    @State private var status = "idle";
    @AppStorage("currentUser") private var currentUser = 0
    @Environment(\.managedObjectContext) private var viewContext;
    
    
    private var isError: Binding<Bool> {
          return Binding<Bool>(
              get: {
                  return status == "error"
              },
              set: { newValue in
                  status = newValue ? "error" : "idle"
              }
          )
      }

    var body: some View {
        VStack {
            Spacer()
            // MARK: -  HEADER
            Group {
                
                ZStack {
                    CircleGroupView(ShapeColor: .accentColor, ShapeOpacity: 0.2, frameDim: CGFloat(300), lineWidth: CGFloat(46))
                    Image("postman-logo")
                       .resizable()
                       .frame(width: 200, height: 200)
                       .scaleEffect(isAnimating ? 1.05 : 0.95)
                       .animation(.easeOut(duration: 1), value: isAnimating)
                       .onAppear {
                           withAnimation {
                               isAnimating = true
                           }
                       }
                }
                
                VStack {
                    Text("Welcome to Postman on Mobile")
                        .foregroundColor(.accentColor)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                        
                    
                    Text("Access all your APIs on the go!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                }
            }
            .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                    }

            

            
            // MARK: -  INPUT SECTION
            VStack {
                HStack {
                    TextField("Enter your api key to get started", text: $apiKey)
                        .bottomBorderStyle()
                        .alert(isPresented: isError) {
                            Alert(title: Text("Error"), message: Text("Seems like you have input an invalid API key. Try creating a new one!"), dismissButton: .default(Text("Retry")))

                        }
                        .onChange(of: status) {status in
                            if status == "error" {
                                self.apiKey = "";
                            }
                        }

                    Button( action: {
                        self.status = "loading"
                        fetchUserDetailsWith(apiKey: apiKey) { userResponse, statusCode in
                            if (statusCode == 401) {
                                self.status = "error"
                            }
                            
                            if (statusCode == 200) {
                                if let user = userResponse?.user {
                                   let isUserCreated =  createNewUserWith(context: viewContext, user: user, apiKey: apiKey)
                                    
                                    if isUserCreated {
                                        withAnimation(.easeOut(duration: 2)) {
                                            currentUser = Int(user.id);
                                        }
                                        self.status = "success"
                                    } else {
                                        // handle error
                                        Alert(title: Text("Unable to add user, try again"))
                                    }
                                }
                            
                            }
                        }
                        
                    }, label: {
                        
                        if (self.status == "loading") {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        } else {
                            Image(systemName: "arrow.right.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    })
                    .disabled(apiKey.isEmpty)
                    
                } // : Hstack
                .padding()
                
                HStack {
                    Text("Learn how to get an Api Key")
                        .foregroundColor(.accentColor)
                        .font(.subheadline)
                    Image(systemName: "arrow.up.right.circle")
                        .foregroundColor(.accentColor)
                }
                
                
            }
            .padding(.top, 40)
            
            Spacer()
            
        }
                
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
