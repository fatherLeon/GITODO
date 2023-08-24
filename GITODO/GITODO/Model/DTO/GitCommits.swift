//
//  GitCommits.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gitCommits = try? JSONDecoder().decode(GitCommits.self, from: jsonData)

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

// MARK: - CommitAuthor
struct CommitAuthor: Codable {
    let date: String
}
