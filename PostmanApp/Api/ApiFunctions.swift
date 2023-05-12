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

func fetch<T: Codable>(urlRequest: URLRequest) async throws -> T {

    let (data, resposne) = try await URLSession.shared.data(for: urlRequest);
    
    guard let httpResponse =  resposne as? HTTPURLResponse else {
        print("Unable to read response as HTTP URL Response");
        throw NSError(domain: "Invalid Response", code: -1);
    }
    
    if !(200...299).contains(httpResponse.statusCode) {
        throw NSError(domain: "Bad response code", code: httpResponse.statusCode);
    }
    
    let decodedResponse = try JSONDecoder().decode(T.self, from: data);
    return decodedResponse;
}

func fetchWorkspacesWith(_ apikey: String) async throws -> [Workspace] {
    let urlRequest: URLRequest = getUrlRequestWith(apiKey: apikey, path: "/workspaces");
    
    let fetchResposne: WorkspaceResponse = try await fetch(urlRequest: urlRequest)
    return fetchResposne.workspaces;

}

func fetchCollectionsFor(workspaceId: String, apiKey: String) async throws -> [Collection] {
    let urlRequest: URLRequest = getUrlRequestWith(apiKey: apiKey, path: "/collections?workspace=\(workspaceId)");
    
    let collectionsList:CollectionResposne = try await fetch(urlRequest: urlRequest)
    return collectionsList.collections;
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
