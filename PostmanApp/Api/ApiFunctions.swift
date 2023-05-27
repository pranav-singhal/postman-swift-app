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

func fetchCollectionRequestsWith(apiKey: String, collectionId: String) async throws -> CollectionResponse.CollectionInfo {
    let urlRequest: URLRequest = getUrlRequestWith(apiKey: apiKey, path: "/collections/\(collectionId)");

    let collectionResponse: CollectionResponse = try await fetch(urlRequest: urlRequest)
    return collectionResponse.collection
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

func handlePlayRequest(url: String, headers: [HeaderObject], requestBody: RequestBody?, method: String) async throws -> (HTTPURLResponse, Data) {
    
    let urlString = replacePlaceholders(in: url, with: [:])
    
    guard let url = URL(string: urlString) else {
        print("Unable to create URL for \(url)")
        throw NSError(domain: "Invalid URL", code: -1)
    }

    var urlRequest = URLRequest(url: url);
    urlRequest.httpMethod = method;
    if requestBody?.mode == "raw" {
        urlRequest.httpBody = requestBody?.raw?.data(using: .utf8)
    }
    
    
    
    if (headers.count > 0 ) {
        for header in headers {
            if header.enabled {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
    }
    let (data, resposne) = try await URLSession.shared.data(for: urlRequest);
    
        
    guard let httpResponse =  resposne as? HTTPURLResponse else {
        print("Unable to read response as HTTP URL Response");
        throw NSError(domain: "Invalid Response", code: -1);
    }
    
    return (httpResponse, data)
    
    
}
