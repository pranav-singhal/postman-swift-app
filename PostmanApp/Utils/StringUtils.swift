//
//  StringUtils.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 15/05/23.
//

import Foundation

enum QueryParamValue: Hashable {
  case string(String)
  case boolean(Bool)
    
//    func toString (self) -> String {
////        if let selfString = self.strin
//    }
    
//    var description: String {
//        switch self {
//        case .string(String): return String;
//        case .boolean(Bool): return Bool;
//        }
//    }
}

func replacePlaceholders(in string: String, with object: [String: String]) -> String {
    var result = string

    let startTag = "{{"
    let endTag = "}}"

    let placeholders = string.split(separator: startTag)

    for placeholder in placeholders.dropFirst() {
        if let closingBraceRange = placeholder.range(of: endTag)?.lowerBound {
            let key = String(placeholder[..<closingBraceRange]);
            
            if let value = object[key] {
                let placeholderString = "\(startTag)\(key)\(endTag)"
                result = result.replacingOccurrences(of: placeholderString, with: "\(value)")
            } else {
                let placeholderString = "\(startTag)\(key)\(endTag)"
                result = result.replacingOccurrences(of: placeholderString, with: "")
            }
            
        }
        
    }

    return result
}

struct QueryParam: Hashable, Equatable {
    var name: String
    var value: String
    var enabled: Bool
}


func getQueryParamsFor(url: String) -> [QueryParam] {
    var queryParams: [QueryParam] = [];

  let urlComponents = URLComponents(string: url)
  if let queryItems = urlComponents?.queryItems {
    for queryItem in queryItems {
        if let queryValue = queryItem.value {
            queryParams.append(QueryParam(name: queryItem.name, value: queryValue, enabled: true))
        }
        
    }
  }

  return queryParams
}

func addQueryItemsTo(url: String, items: [QueryParam]) -> String {
    var queryString = "";
    
    for queryParam in items {
        if !queryString.isEmpty {
            queryString += "&";
        }
        queryString += "\(queryParam.name)=\(queryParam.value)";
    }
    
    if url.contains("?") {
        return url.split(separator: "?")[0] + "?" + queryString;
    }
    
    return url + "?" + queryString;
}
