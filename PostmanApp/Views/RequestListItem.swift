//
//  RequestListItem.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 16/05/23.
//

import SwiftUI

struct RequestListItem: View {
    @State var request: Request;
    @State var name: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                Text(name ?? "Unnamed Request")


            }
            .padding(.bottom, 10)

            HStack {
                Text(request.method)
                    .foregroundColor(.accentColor)
                Text(request.url.raw)
                    .font(.subheadline)
                    .italic()

            }
        }
        .onAppear {
            print("START**********")
            print(request.url)
            print(request.header)
            print("END**********")
        }
        
    }
}

struct RequestListItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RequestListItem(request: Request(method: "POST", header: [
                ["value": .string("key")]
                
            ], url: RequestUrl(raw: "www.google.com")), name: "Create google")
            RequestListItem(request: Request(method: "POST", header: [["value": .string("key")]], url: RequestUrl(raw: "www.google.com")), name: "Create google")
        }
        
    }
}
