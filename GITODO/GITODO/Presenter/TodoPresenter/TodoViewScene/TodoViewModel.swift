//
//  TodoViewModel.swift
//  GITODO
//
//  Created by 강민수 on 2023/10/05.
//

import Foundation

final class TodoViewModel {
    let today = Date()
    var selectedDate = Date()
    var currentPage: Date?
    var todos: [TodoObject] = []
    var repos: [String: Date] = [:]
    var maxCommitedNum = 0
    
    private let coredataManager = CoreDataManager.shared
    private let gitManager = GitManager()
    private let userDefaultManager = UserDefaultManager()
    
    func fetchCommitByDay(year: Int, month: Int, day: Int) -> Int {
        guard let commitObject = try? coredataManager.searchOne("\(year)-\(month)-\(day)", type: CommitByDateObject.self) as? CommitByDateObject else { return 0 }
        
        let commitedNum = commitObject.commitedNum
        
        return Int(commitedNum)
    }
}
