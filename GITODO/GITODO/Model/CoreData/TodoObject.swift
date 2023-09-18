//
//  TodoObject.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/25.
//

import CoreData
import Foundation

struct TodoObject: Interactionable, Identifiable {
    static var entityType: NSManagedObject.Type = Todo.self
    static var entityName: String = "Todo"
    
    var id: String
    var storedDate: Date
    let year: Int16
    let month: Int16
    let day: Int16
    let hour: Int16
    let minute: Int16
    let second: Int16
    let title: String
    let memo: String
    var isComplete: Bool
    
    init(year: Int16, month: Int16, day: Int16, hour: Int16, minute: Int16, second: Int16, title: String, memo: String, storedDate: Date, isComplete: Bool) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.id = "\(year)-\(month)-\(day)"
        self.title = title
        self.memo = memo
        self.storedDate = storedDate
        self.isComplete = isComplete
    }
    
    func transform() -> NSManagedObject {
        let todo = Todo()
        
        todo.hour = hour
        todo.minute = minute
        todo.title = title
        todo.memo = memo
        
        return todo
    }
    
    static func transform(_ data: NSManagedObject) -> Interactionable? {
        guard let data = data as? Todo,
              let title = data.title,
              let memo = data.memo,
              let storedDate = data.storedDate else { return nil }
        
        return TodoObject(year: data.year, month: data.month, day: data.day, hour: data.hour, minute: data.minute, second: data.second, title: title, memo: memo, storedDate: storedDate, isComplete: data.isComplete)
    }
    
    static func getTodosNearest(by date: Date, todos: [TodoObject]) -> [TodoObject] {
        let filteredTodos = todos.filter { todo in
            let (standardHour, _) = date.convertDateToHourMinute()!
            
            if todo.hour >= standardHour {
                return true
            } else {
                return false
            }
        }
        let noCompletedTodos = filteredTodos.filter { $0.isComplete == false }
        let sortedTodos = noCompletedTodos.sorted { lhs, rhs in
            return Date.convertDate(year: lhs.year, month: lhs.month, day: lhs.day, hour: lhs.hour, minute: lhs.minute) < Date.convertDate(year: rhs.year, month: rhs.month, day: rhs.day, hour: rhs.hour, minute: rhs.minute)
        }
        
        return sortedTodos
    }
}
