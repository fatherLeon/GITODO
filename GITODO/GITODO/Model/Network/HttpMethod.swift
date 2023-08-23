//
//  HttpMethod.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/23.
//

import Foundation

enum HttpMethod {
    case GET
    case POST
    case PUT
    case DELETE
    
    var method: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .PUT:
            return "PUT"
        case .DELETE:
            return "DELETE"
        }
    }
}
