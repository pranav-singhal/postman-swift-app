//
//  RequestObjectModel.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 15/05/23.
//

import Foundation

struct CollectionItemModel: Codable, Identifiable {
    var name: String?
    var id: String?
    var request: Request?
    var item: [CollectionItemModel]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.request = try container.decodeIfPresent(Request.self, forKey: .request)
        self.item = try container.decodeIfPresent([CollectionItemModel].self, forKey: .item)
    }
}



struct RequestUrl: Codable {
    struct RequestUrlQuery: Codable {
        var key: String
        var value: String
        var description: String
        var disabled: Bool?
    }

    var raw: String
    var query: [RequestUrlQuery]?
}

enum HeaderValue: Codable {
    case string(String)
    case int(Int)
    case bool(Bool)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid header value")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string):
            try container.encode(string)
        case .int(let int):
            try container.encode(int)
        case .bool(let bool):
            try container.encode(bool)
        }
    }
}

struct Request: Codable {
    var method: String;
    var header: [[String: HeaderValue]];
    var url: RequestUrl
//    var url: [[String: String]];
}


struct CollectionResponse: Codable {

    struct CollectionMeta: Codable {
        var name: String?
        var description: String?    }
    struct CollectionInfo: Codable{
        var item: [CollectionItemModel]
        var info: CollectionMeta
    }


    var collection: CollectionInfo
}
