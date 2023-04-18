//
//  WorkspaceModel.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 17/04/23.
//

import Foundation

struct Workspace: Codable, Identifiable {
    var id: String;
    var name: String;
    var type: String;
    var visibility: String;
}

//"id": "1f0df51a-8658-4ee8-a2a1-d2567dfa09a9",
//"name": "Test Workspace",
//"type": "personal",
//"visibility": "personal"
