//
//  ResponseView.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 27/05/23.
//

import SwiftUI
import CodeEditor

func getLanguageFrom(langString: String) -> CodeEditor.Language {
    if langString == "json" {
        return .json
    }
    
    if langString == "javascript" {
        return .javascript
    }
    
    return .json;
}

struct ResponseView: View {
    @Binding var source: String;
    
    @Binding var language: String;
    var body: some View {
        VStack(alignment: .leading) {
            Text("Response")
                .font(.title)
                .foregroundColor(.accentColor)
            if language == "html" {
                MdViewer(mdString: $source)
            } else {
                CodeEditor(
                    source: $source,
                    language: getLanguageFrom(langString: language)
                )
                .border(.gray)
            }

            
            
            
        }
        .padding()
        
    }
}

struct ResponseView_Previews: PreviewProvider {
    static var previews: some View {
        ResponseView(source: .constant("<div> </div>"), language: .constant("html"))
    }
}
