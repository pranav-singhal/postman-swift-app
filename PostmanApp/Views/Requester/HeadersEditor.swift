//
//  HeadersEditor.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 25/05/23.
//

import SwiftUI

struct HeadersEditor: View {
    @Binding var headers: [HeaderObject];

    var body: some View {
        
            
        List {
            ForEach($headers.indices, id: \.self) { i in
                            
                            HStack {
                                Toggle(isOn: self.$headers[i].enabled) {
                                    Text("")
                                }
                                .frame(width: 60)
                                .padding(.leading, 0)
                                
                                TextField("Name", text: self.$headers[i].key)
                                
                                TextField("Value", text: self.$headers[i].value)
                       
                            }
                        }
            Button("Add Headers") {
                headers.append(HeaderObject(key: "", value: "", enabled: true))
            }
        }
    }
}

struct HeadersEditor_Previews: PreviewProvider {
    static var previews: some View {
        HeadersEditor(headers: .constant([HeaderObject(key: "Content-type", value: "application/json", enabled: true)]))
    }
}
