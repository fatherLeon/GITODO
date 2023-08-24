//
//  GitRepository.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

typealias GitRepositories = [GitRepository]

struct GitRepository: Decodable {
    let id: Int
    let nodeID, name, fullName: String

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
    }
}
