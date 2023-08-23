//
//  EndPoint.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/22.
//

import Foundation

enum EndPoint {
    //https://api.github.com/users/geniusin/repos
    case repository(user: String)
    
    //https://api.github.com/repos/fatherLeon/GITODO/commits
    case commits(user: String, repository: String)
    
    private var root: String {
        return "https://api.github.com/"
    }
}
