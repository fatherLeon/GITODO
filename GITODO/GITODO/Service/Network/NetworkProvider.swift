//
//  NetworkManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/22.
//

import Foundation

struct NetworkProvider {
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}
