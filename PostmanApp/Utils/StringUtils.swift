//
//  StringUtils.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 15/05/23.
//

import Foundation

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
