//
//  AddingTodoViewModel.swift
//  GITODO
//
//  Created by 강민수 on 2023/10/05.
//

import RxSwift
import Foundation

final class AddingTodoViewModel {
    let targetDate: Date
    let todoObject: TodoObject?
    
    private let coredataManager = CoreDataManager.shared
    
    let todoTitleText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let todoMemoText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let todoDate: BehaviorSubject<Date>
    
    var isWritingCompleted: Observable<Bool> {
        return todoTitleText
            .map { title in
                return title.isEmpty == false
            }
    }
    
    init(targetDate: Date, todoObject: TodoObject?) {
        self.targetDate = targetDate
        self.todoObject = todoObject
        self.todoDate = BehaviorSubject(value: targetDate)
    }
    
    func processTodo() -> Bool {
        guard let todoTitle = try? todoTitleText.value() else {
            return false
        }
        
        return todoObject == nil ? save() : update()
    }
    
    private func save() -> Bool {
        guard let todo = makeTodoObject() else { return false }
        
        do {
            try coredataManager.save(todo)
            return true
        } catch {
            return false
        }
    }
    
    private func update() -> Bool {
        guard let storedDate = todoObject?.storedDate,
              let todo = makeTodoObject() else { return false }
        
        do {
            try coredataManager.update(storedDate: storedDate, data: todo, type: TodoObject.self)
            return true
        } catch {
            return false
        }
    }
    
    private func makeTodoObject() -> TodoObject? {
        guard let todoTitle = try? todoTitleText.value(),
              let todoMemo = try? todoMemoText.value(),
              let todoDate = try? todoDate.value() else {
            return nil
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: todoDate
        )
        guard let year = components.year,
              let month = components.month,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute,
              let second = components.second else { return nil }
        
        let todo = TodoObject(year: Int16(year), month: Int16(month), day: Int16(day), hour: Int16(hour), minute: Int16(minute), second: Int16(second), title: todoTitle, memo: todoMemo, storedDate: todoDate, isComplete: false)
        
        return todo
    }
}
