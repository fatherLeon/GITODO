//
//  EndPoint.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/22.
//

import Foundation

protocol Requestable {
    var url: URL? { get }
    
    func makeUrlRequest(httpMethod: HttpMethod) throws -> URLRequest
}

enum EndPoint: Requestable {
    //https://api.github.com/users/fatherLeon/repos
    case repository(user: String)
    
    //https://api.github.com/repos/fatherLeon/FOFMAP/commits
    case commits(fullName: String, perPage: Int = 30, page: Int = 1)
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        return "api.github.com"
    }
    
    private var path: String {
        switch self {
        case .repository(let user):
            return "/users/\(user)/repos"
        case .commits(let fullName, _, _):
            return "/repos/\(fullName)/commits"
        }
    }
    
    private var querys: [URLQueryItem] {
        switch self {
        case .repository(_):
            return []
        case .commits(_, let perPage, let page):
            let perPageItem = URLQueryItem(name: "per_page", value: "\(perPage)")
            let pageItem = URLQueryItem(name: "page", value: "\(page)")
            
            return [perPageItem, pageItem]
        }
    }
    
    var url: URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = querys
        
        return urlComponents.url
    }
    
    func makeUrlRequest(httpMethod: HttpMethod) throws -> URLRequest {
        guard let url = url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.method
        
        return request
    }
}
