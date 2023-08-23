//
//  EndPoint.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/22.
//

import Foundation

protocol Requestable {
    var url: URL? { get }
}

enum EndPoint: Requestable {
    //https://api.github.com/users/geniusin/repos
    case repository(user: String)
    
    //https://api.github.com/repos/fatherLeon/GITODO/commits
    case commits(user: String, repository: String)
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        return "api.github.com"
    }
    
    private var path: String {
        switch self {
        case .repository(let user):
            return "users/\(user)/repos"
        case .commits(let user, let repository):
            return "repos/\(user)/\(repository)/commits"
        }
    }
    
    var url: URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        return urlComponents.url
    }
}
