//
//  GitRepository.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

typealias GitRepositories = [GitRepository]

// MARK: - GitRepository
struct GitRepository: Codable {
    let name, fullName: String
    let owner: Owner
    let description: String?
    let createdAt, updatedAt: String
    let language: String?

    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case owner
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case language
    }
}

// MARK: - Owner
struct Owner: Codable {
    let avatarURL: String
    let gravatarID: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
    }
}
