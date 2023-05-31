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
    @State var headers: [HeaderObject] = [];
    
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

            headers = request.header.map{
                HeaderObject(key: $0.key, value: $0.value, enabled: ($0.disabled ?? false) ? false : true )
            };
        }
        .onTapGesture {
            showRequestPage = true
        }
        .fullScreenCover(isPresented: $showRequestPage) {
            RequesterUI(url: request.url.raw, requestMethod: request.method, requestTitle: $name, showRequestPage: $showRequestPage, queryParams: $queryParams, headers: $headers, requestBody: $request.body)
        }
    }
}

struct RequestListItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RequestListItem(request: Request(method: "POST", header: [
                Header(key: "max-cookie-age", value: "500")
                
            ], url: RequestUrl(raw: "www.google.com")), name: "Create google")
            RequestListItem(request: Request(method: "POST", header: [Header(key: "Content-Type", value: "application/json")], url: RequestUrl(raw: "www.google.com")), name: "Create google")
        }
        
    }
}
