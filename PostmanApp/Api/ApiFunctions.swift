//
//  ApiFunctions.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 17/04/23.
//

import Foundation
import SwiftUI

func getUrlRequestWith (apiKey: String, path: String) -> URLRequest {
    let url = URL(string: "https://api.getpostman.com\(path)")! ;
    var urlRequest = URLRequest(url: url);
    urlRequest.setValue(apiKey, forHTTPHeaderField: "X-Api-Key");
    return urlRequest;
}

func fetchWorkspacesWith(_ apikey: String) async throws -> [Workspace] {
    let urlRequest: URLRequest = getUrlRequestWith(apiKey: apikey, path: "/workspaces");
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        print("Unable to read response as HTTP URL Response");
        throw NSError(domain: "Invalid response", code: -1);
    }

    if !(200...299).contains(httpResponse.statusCode) {
        throw NSError(domain: "Invalid response", code: httpResponse.statusCode);
    }

    let workspaceList = try JSONDecoder().decode(WorkspaceResponse.self, from: data)
    return workspaceList.workspaces

    throw NSError(domain: "Invalid data", code: 0)

}


func fetchUserDetailsWith( apiKey: String, completionHandler: @escaping (UserResponseType?, Int) -> Void) {
    let urlRequest :URLRequest = getUrlRequestWith(apiKey: apiKey, path: "/me");
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        if let error = error {
            print("Error when fetching user details: \(error)")
            return;
            
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if !(200...299).contains(httpResponse.statusCode) {
                completionHandler(nil, httpResponse.statusCode);
                return;
            }
            
            
            
            if let data = data,
               let user = try? JSONDecoder().decode(UserResponseType.self, from: data) {
                completionHandler(user, httpResponse.statusCode)
            } else {
                print("Unable to decode data")
            }
        }
        

        
    }
    task.resume();
}
