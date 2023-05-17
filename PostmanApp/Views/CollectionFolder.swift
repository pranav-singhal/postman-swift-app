//
//  CollectionFolder.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 16/05/23.
//

import SwiftUI

struct CollectionFolder: View {
    @State var folderItems: [CollectionItemModel]
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
    
    static let jsonString = """
    {
      "name": "Example Name",
      "id": "123",
      "request": {
        "method": "POST",
        "header": [
    {
    "value": "key"
    }
    ],
    "url": {
    "raw": "www.goog.com"
    }
      },
      "item": [
        {
          "name": "Subitem 1",
          "id": "456",
          "request": null,
          "item": null
        },
        {
          "name": "Subitem 2",
          "id": "789",
          "request": null,
          "item": null
        }
      ]
    }
    """
    
    static let decoder = JSONDecoder()

    static var previews: some View {
        CollectionFolder(folderItems: [try! decoder.decode(CollectionItemModel.self, from: jsonString.data(using: .utf8)!)])
    }
}
