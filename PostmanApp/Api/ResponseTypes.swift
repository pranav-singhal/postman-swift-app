//
//  ResponseTypes.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 29/04/23.
//

import Foundation

struct UserType: Codable{
    var id: Int64;
    var username: String;
    var email: String;
    var fullName: String;
    var avatar: String?;
    var isPublic: Bool
}

struct UserResponseType: Codable {
    var user: UserType
}
    
