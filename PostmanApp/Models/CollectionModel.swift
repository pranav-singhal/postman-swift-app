//
//  CollectionModel.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 10/05/23.
//

import Foundation

struct Collection: Codable, Identifiable {
    var id: String;
    var uid: String;
    var name: String;
    var createdAt: String;
    var updatedAt: String;
    var fork: Fork?
    
    struct Fork: Codable {
        var label: String;
        var createdAt: String;
        var from: String;
    }
    
}

struct CollectionResposne: Codable {
    var collections: [Collection]
}

// MARK: -  Sample response
//"id": "123-123-123-a1fa-123",
//            "name": "Figletify",
//            "owner": "21760746",
//            "createdAt": "2022-09-16T15:18:47.000Z",
//            "updatedAt": "2022-09-16T15:18:47.000Z",
//            "uid": "21760746-9c6ce814-b626-45f0-a1fa-255b30bf1260",
//            "fork": {
//                "label": "Figletify",
//                "createdAt": "2022-09-16T15:02:19.000Z",
//                "from": "21760746-123-06e0-123-b5c6-aba0a7ae471b"
//            },
//            "isPublic": true
