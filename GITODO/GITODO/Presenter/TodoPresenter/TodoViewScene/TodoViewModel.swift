//
//  TodoViewModel.swift
//  GITODO
//
//  Created by 강민수 on 2023/10/05.
//

import RxSwift
import Foundation
import FSCalendar

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
    
    func processCommit(_ data: GitCommit) {
        guard let date = Date.toISO8601Date(data.commit.author.date),
              let (year, month, day) = date.convertDateToYearMonthDay() else { return }
        
        guard var targetObejct = fetchCommitByDay(year: year, month: month, day: day) else {
            try? saveCommit(year: year, month: month, day: day)
            return
        }
        
        targetObejct.commitedNum += 1
        try? updateCommit(targetObejct)
    }
    
    func changeCalendarViewCurrentPage(value: Int, scopeMode: FSCalendarScope) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        switch scopeMode {
        case .week:
            dateComponents.weekOfMonth = value
        case .month:
            dateComponents.month = value
        @unknown default:
            return
        }
        
        currentPage = calendar.date(byAdding: dateComponents, to: currentPage ?? today)
    }
    
    func fetchCommitByDay(year: Int, month: Int, day: Int) -> CommitByDateObject? {
        guard let commitObject = try? coredataManager.searchOne("\(year)-\(month)-\(day)", type: CommitByDateObject.self) as? CommitByDateObject else { return nil }
        
        return commitObject
    }
    
    func fetchTodos(by date: Date) -> [TodoObject] {
        guard let components = date.convertDateToYearMonthDay() else { return [] }
        
        let targetId = "\(components.year)-\(components.month)-\(components.day)"
        
        guard let todos = coredataManager.search(targetId, type: TodoObject.self) as? [TodoObject] else {
            return []
        }
        
        return todos
    }
    
    func updateTodo(_ data: TodoObject) throws {
        try coredataManager.update(storedDate: data.storedDate, data: data, type: TodoObject.self)
    }
    
    func deleteTodo(_ data: TodoObject) throws {
        try coredataManager.delete(storedDate: data.storedDate, type: TodoObject.self)
    }
    
    func saveCommit(year: Int, month: Int, day: Int) throws {
        let object = CommitByDateObject(year: year, month: month, day: day, storedDate: Date(), commitedNum: 1)
        
        try coredataManager.save(object)
    }
    
    func updateCommit(_ data: CommitByDateObject) throws {
        try coredataManager.update(storedDate: data.storedDate, data: data, type: CommitByDateObject.self)
    }
    
    func calculateMaxCommitedNum() {
        guard let data = coredataManager.fetch(CommitByDateObject.self) as? [CommitByDateObject],
              let maxCommitedNum = data.max(by: { $0.commitedNum < $1.commitedNum })?.commitedNum else { return }
        
        self.maxCommitedNum = Int(maxCommitedNum)
    }
    
    func fetchRepos() -> [String: Date] {
        let repos = userDefaultManager.fetchRepos(by: UserDefaultManager.repositoryKey)
        
        return repos
    }
    
    func fetchCommits(repoFullName: String, perPage: Int = 100, page: Int, since: Date, until: Date = Date(), completion: @escaping (GitCommits) -> Void) {
        gitManager.searchCommits(by: repoFullName, perPage: perPage, page: page, since: since, until: until, completion: completion)
    }
    
    func saveRepos() {
        userDefaultManager.saveRepos(repos, UserDefaultManager.repositoryKey)
    }
}
