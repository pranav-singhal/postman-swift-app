//
//  CollectionFolder.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 16/05/23.
//

import SwiftUI

struct CollectionFolder: View {
    @State var folderItems: [CollectionSubItemModel]
    var body: some View {
        VStack {
            List {
                ForEach(folderItems) { item in
                    if let request = item.request {
                        RequestListItem(request: request, name: item.name ?? "")
                    } else {
                        if let _subFolder = item.item {
                            NavigationLink(destination: CollectionFolder(folderItems: _subFolder)) {
                                HStack {
                                    Image(systemName: "folder")
                                    Text(item.name ?? "folder")
                                }
                            }
                        }
                    }
                    
                }
            }
            
        }
    }
}

struct CollectionFolder_Previews: PreviewProvider {
    static let sampleRequest = Request(method: "POST", header: [["value": .string("key")]], url: RequestUrl(raw: "www.google.com"))
    static var previews: some View {
        CollectionFolder(folderItems: [CollectionSubItemModel(id: "uuid-123", request: sampleRequest)])
    }
}
