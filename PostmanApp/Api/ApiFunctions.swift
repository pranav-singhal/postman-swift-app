//
//  ApiFunctions.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 17/04/23.
//

import Foundation

func getUrlRequestWith (apiKey: String, path: String) -> URLRequest {
    let url = URL(string: "https://api.getpostman.com\(path)")! ;
    var urlRequest = URLRequest(url: url);
    urlRequest.setValue(apiKey, forHTTPHeaderField: "X-Api-Key");
    return urlRequest;
}

func fetchWorkspacesWith(_ apikey: String, completionHandler: @escaping ([Workspace]) -> Void) {
    let urlRequest: URLRequest = getUrlRequestWith(apiKey: apikey, path: "/workspaces");
    
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        if let error = error {
          print("Error with fetching films: \(error)")
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, unexpected status code: \(String(describing: response))")
           return
         }
        if let data = data,
                let workspaceList = try? JSONDecoder().decode(WorkspaceResponse.self, from: data) {
            completionHandler(workspaceList.workspaces )
        };
            
        
    }
    task.resume()
}
