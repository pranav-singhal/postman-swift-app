//
//  QueryParamsEditor.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 19/05/23.
//

import SwiftUI

struct QueryParamsEditor: View {
    @Binding var queryParams: [QueryParam];

    @Binding var targetUrl: String;

    var body: some View {
        
        List {
            ForEach($queryParams.indices, id: \.self) { i in
                
                HStack {
                    Toggle(isOn: self.$queryParams[i].enabled) {
                        Text("")
                    }
                    .frame(width: 60)
                    .padding(.leading, 0)
                    
                    TextField("Name", text: self.$queryParams[i].name)
                    
                    TextField("Value", text: self.$queryParams[i].value)
           
                }
            }
            Button("Add query param") {
                queryParams.append(QueryParam(name: "key", value: "", enabled: true))
            }
            
        }
        .onChange(of: queryParams) { _queryParams in

            let enabledQueryParams = _queryParams.filter {$0.enabled}

            if enabledQueryParams.count > 0 {
                targetUrl = addQueryItemsTo(url: targetUrl, items: enabledQueryParams)
            } else {
                targetUrl = addQueryItemsTo(url: targetUrl, items: [])
            }
        }
    }
}

struct QueryParamsEditor_Previews: PreviewProvider {
    static var previews: some View {
        QueryParamsEditor(queryParams:
                .constant(
                    [
                        QueryParam(name: "foo", value: "bar", enabled: true),
                        QueryParam(name: "foo2", value: "bar2", enabled: false)
                    ]
                )
        ,
                          targetUrl: .constant("www.google.com?foo=bar&foo2=bar2")
        )
    }
}
