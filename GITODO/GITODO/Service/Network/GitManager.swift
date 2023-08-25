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
    
    func searchRepos(by nickname: String, completion: @escaping (GitRepositories) -> Void) {
        let requestable = EndPoint.repository(user: nickname)
        
        try? network.request(by: GitRepositories.self, with: requestable) { result in
            switch result {
            case .success(let data):
                guard let data = data as? GitRepositories else {
                    completion([])
                    return
                }
                
                completion(data)
            case .failure(_):
                completion([])
            }
        }
    }
    
    func searchCommits(by fullName: String, perPage: Int = 30, page: Int = 1, since: Date, until: Date, completion: @escaping (GitCommits) -> Void) {
        let requestable = EndPoint.commits(fullName: fullName, perPage: perPage, page: page, since: since, until: until)
        
        try? network.request(by: GitCommits.self, with: requestable, { result in
            switch result {
            case .success(let data):
                guard let data = data as? GitCommits else {
                    completion([])
                    return
                }
                
                completion(data)
            case .failure(_):
                completion([])
            }
        })
    }
}
