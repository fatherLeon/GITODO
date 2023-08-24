//
//  GitManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

final class GitManager {
    private let network: NetworkProvider
    
    init(session: URLSession = .shared) {
        self.network = NetworkProvider(session: session)
    }
}
