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
    @State var requestMethod: String = "POST";
    @Binding var showRequestPage: Bool;
    @Binding var queryParams: [QueryParam];

    var body: some View {
        VStack {
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
                            print("Play request")
                        }) {
                            Image(systemName: "play.fill")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.top, 50)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                }
                .ignoresSafeArea()
                .frame(height: 40)
            
            
            Spacer()
            
            // MARK: -  Request URL Section
            HStack{
                Picker("Method", selection: $requestMethod) {
                    ForEach(allowedRequestMethods, id: \.self) {
                        Text($0).tag($0)
                    }
                   }
                
                TextField("", text: $url)
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
                                var _newQueryParam = newQueryParams.filter{_newQueryParam in
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
                
            } //: Request URL Section
            .padding()
            QueryParamsEditor(queryParams: $queryParams, targetUrl: $url)
            Spacer()
            // MARK: -  Request Body and Header section
            
            // MARK: -  Request section
        }
    }
}

struct RequesterUI_Previews: PreviewProvider {
    static var previews: some View {
        RequesterUI(showRequestPage: .constant(true), queryParams: .constant([]))
    }
}
