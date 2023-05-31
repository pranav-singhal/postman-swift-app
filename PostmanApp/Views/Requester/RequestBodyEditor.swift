//
//  RequestBodyEditor.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 27/05/23.
//

import SwiftUI
import CodeEditor

struct RequestBodyEditor: View {
    @Binding var requestBody: RequestBody?;
    @Environment(\.colorScheme) var colorScheme;
    @State private var requestBodyString: String = "";
    var body: some View {
        VStack {
            if (colorScheme == .dark ){
                CodeEditor(
                    source: $requestBodyString,
                    theme: .atelierSavannaLight,
                    flags: [.editable, .selectable, .smartIndent ],
                    autoPairs: [ "{": "}", "<": ">", "'": "'", "\"": "\"", "(" : ")" ]
                )
            } else {
                CodeEditor(
                    source: $requestBodyString,
                    flags: [.editable, .selectable, .smartIndent ],
                    autoPairs: [ "{": "}", "<": ">", "'": "'", "\"": "\"", "(" : ")" ]
                )
            }
            
            
        }.onAppear{
            if requestBody?.mode == "raw" {
                requestBodyString = requestBody?.raw ?? ""
            }
        }
        .onChange(of: requestBodyString) { newRequestString in
            requestBody?.raw = newRequestString   
        }
        
        
    }
        
}

struct RequestBodyEditor_Previews: PreviewProvider {
    static var previews: some View {
        RequestBodyEditor(requestBody: .constant(RequestBody(raw: """
 "{\n    \"collection\": {\n        \"info\": {\n            \"name\": \"{{collectionName}}\",\n            \"schema\": \"{{collectionSchemaUrl}}\"\n        },\n        \"item\": [\n            {\n                \"request\": {}\n            }\n        ]\n    }\n}"
 """, mode: "raw")))
    }
}
