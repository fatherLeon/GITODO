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
    case commits(fullName: String, perPage: Int, page: Int, since: Date, until: Date)
    
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
        case .commits(let fullName, _, _, _, _):
            return "/repos/\(fullName)/commits"
        }
    }
    
    private var querys: [URLQueryItem] {
        switch self {
        case .repository(_):
            return []
        case .commits(_, let perPage, let page, let since, let until):
            let perPageItem = URLQueryItem(name: "per_page", value: "\(perPage)")
            let pageItem = URLQueryItem(name: "page", value: "\(page)")
            let sinceItem = URLQueryItem(name: "since", value: Date.toISO8601String(since))
            let untilItem = URLQueryItem(name: "until", value: Date.toISO8601String(until))
            
            return [perPageItem, pageItem, sinceItem, untilItem]
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
