//
//  RequesterUI.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 18/05/23.
//

import SwiftUI

let allowedRequestMethods: [String] = ["GET", "POST", "PATCH", "PUT"];

struct RequesterUI: View {
    @State var url: String = "https://";
    @State var requestMethod: String = "GET";
    @Binding var requestTitle: String?;
    @Binding var showRequestPage: Bool;
    @Binding var queryParams: [QueryParam];
    @Binding var headers: [HeaderObject];
    @State var responseString: String?;
    @State var showResponseSheet: Bool = false;

    var body: some View {
        VStack(alignment: .leading) {
            // MARK: -  Toolbar
            
                Color.gray
                .opacity(0.4)
                .overlay {
                    HStack {
                        Button(action: {
                            showRequestPage = false
                        }) {
                            Text("Done")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Button(action: {
                            Task {
                                let (httpResponse, data) = try await handlePlayRequest(url: url, headers: headers)
                                
                                let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type");
                                print(contentType)
                                if (contentType == "application/json; charset=utf-8") {
                                    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                                        responseString = """
                                        ```
                                            \(String(decoding: jsonData, as: UTF8.self))
                                        ```
                                        """
                                        
                                    }
                                    else {
                                        print("json data malformed")
                                    }
//                                    print(String(decoding: data, as: UTF8.self))
//                                    responseString = String(decoding: data, as: UTF8.self);
                                    
                                }else if (contentType == "text/html; charset=ISO-8859-1") {
                                    responseString = String(decoding: data, as: UTF8.self)
                                }
                                showResponseSheet = true;

                            }
                            
                        }) {
                            Image(systemName: "play.fill")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .sheet(isPresented: $showResponseSheet) {
                            MdViewer(mdString: $responseString)
                        }
                        
                    }
                    .padding(.top, 50)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                }
                .ignoresSafeArea()
                .frame(height: 40)
            
            // MARK: -  Request URL Section
            HStack{
                Picker("Method", selection: $requestMethod) {
                    ForEach(allowedRequestMethods, id: \.self) {
                        Text($0).tag($0)
                    }
                   }
                
                Text(requestTitle ?? "Unnamed Request")
                    .font(.title)

            } //: Request details Section
            .padding()
            
            // MARK: -  Request URL Section
            TextField("Enter URL", text: $url, axis: .vertical)
                .bottomBorderStyle()
                .onChange(of: url) { _url in
                    let newQueryParams = getQueryParamsFor(url: _url);
                    let newQueryParamsNotInOldQueryParams = newQueryParams.filter { _newQueryParam in
                        
                        !queryParams.contains { _queryParam in
                            _queryParam.name == _newQueryParam.name
                        }
                        
                    }
                                            
                    newQueryParamsNotInOldQueryParams.forEach{
                        queryParams.append($0)
                    }

                    queryParams = queryParams.map{ _oldQueryParam in
                        var updatedQueryParam = QueryParam(name: _oldQueryParam.name, value: _oldQueryParam.value, enabled: _oldQueryParam.enabled)
                        let isQueryParamInNewQueryParams = newQueryParams.filter { _newQueryParam in
                            _newQueryParam.name == _oldQueryParam.name;
                            
                        }.count != 0;
                        
                        if (isQueryParamInNewQueryParams) {
                            let _newQueryParam = newQueryParams.filter{_newQueryParam in
                                _newQueryParam.name == _oldQueryParam.name
                            }[0]
                            updatedQueryParam.enabled = true
                            updatedQueryParam.value = _newQueryParam.value
                            
                        } else {
                            updatedQueryParam.enabled = false
                        }
                        
                        return updatedQueryParam;
                    }
                }
                .padding() //: Request URL section
            
            
            Form {
                Section("Query Params"){
                    // MARK: -  Query Params Editor
                    QueryParamsEditor(queryParams: $queryParams, targetUrl: $url)
                }
                            
                // MARK: -  Headers Editor
                Section("Headers") {
                    HeadersEditor(headers: $headers)

                }

            }
            
            // MARK: -  Auth Editor

            // MARK: -  Request Body and Header section
            
            // MARK: -  Request section
        }
    }
}

struct RequesterUI_Previews: PreviewProvider {
    static var previews: some View {
        RequesterUI(url: "https://www.google.com?foo=bar&ff2=bar2asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf", requestTitle: .constant("Get a collection"), showRequestPage: .constant(true), queryParams: .constant([
            QueryParam(name: "foo", value: "bar", enabled: true),
            QueryParam(name: "foo2", value: "bar2", enabled: false)
        ]), headers: .constant([HeaderObject(key: "Content-type", value: "application/json", enabled: true)]))
    }
}
