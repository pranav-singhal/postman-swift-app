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
    @State private var showRequestPage: Bool = false;
    @State var queryParams: [QueryParam] = [];
    
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
            queryParams = (request.url.query ?? []).map {
                QueryParam(name: $0.key, value: $0.value, enabled: !($0.disabled ?? false))
                }
        }
        .onTapGesture {
            showRequestPage = true
        }
        .fullScreenCover(isPresented: $showRequestPage) {
            RequesterUI(url: request.url.raw, requestMethod: request.method, showRequestPage: $showRequestPage, queryParams: $queryParams)
        }
    }
}

struct RequestListItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RequestListItem(request: Request(method: "POST", header: [
                ["value": .string("key")]
                
            ], url: RequestUrl(raw: "www.google.com")), name: "Create google")
            RequestListItem(request: Request(method: "POST", header: [["key": .string("Content-Type"), "value": .string("application/json")]], url: RequestUrl(raw: "www.google.com")), name: "Create google")
        }
        
    }
}
