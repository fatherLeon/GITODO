//
//  GitCommits.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

typealias GitCommits = [GitCommit]

// MARK: - GitCommit
struct GitCommit: Codable {
    let commit: Commit

    enum CodingKeys: String, CodingKey {
        case commit
    }
}

struct Commit: Codable {
    let author, committer: CommitAuthor

    enum CodingKeys: String, CodingKey {
        case author, committer
    }
}

struct CommitAuthor: Codable {
    let date: String
}
