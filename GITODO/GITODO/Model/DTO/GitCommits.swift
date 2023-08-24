//
//  GitCommits.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

typealias GitCommits = [GitCommit]

struct GitCommit: Decodable {
    let commit: Commit

    enum CodingKeys: String, CodingKey {
        case commit
    }
}

struct Commit: Decodable {
    let author, committer: CommitAuthor
    let message: String

    enum CodingKeys: String, CodingKey {
        case author, committer, message
    }
}

struct CommitAuthor: Decodable {
    let date: Date
}
