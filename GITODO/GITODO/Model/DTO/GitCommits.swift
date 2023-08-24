//
//  GitCommits.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

typealias GitCommits = [GitCommit]

struct GitCommit: Codable {
    let commit: Commit

    enum CodingKeys: String, CodingKey {
        case commit
    }
}

struct Commit: Codable {
    let author, committer: CommitAuthor
    let message: String

    enum CodingKeys: String, CodingKey {
        case author, committer, message
    }
}

struct CommitAuthor: Codable {
    let date: Date
}
