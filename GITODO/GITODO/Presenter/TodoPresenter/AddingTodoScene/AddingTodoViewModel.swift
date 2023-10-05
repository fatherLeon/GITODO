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
        
        guard let (year, month, day) = todoDate.convertDateToYearMonthDay(),
              let (hour, minute) = todoDate.convertDateToHourMinute() else {
            return nil
        }
        
        if todoMemo == "메모를 입력해주세요" {
            let todo = TodoObject(year: Int16(year), month: Int16(month), day: Int16(day), hour: Int16(hour), minute: Int16(minute), second: 0, title: todoTitle, memo: "", storedDate: todoDate, isComplete: false)
            
            return todo
        } else {
            let todo = TodoObject(year: Int16(year), month: Int16(month), day: Int16(day), hour: Int16(hour), minute: Int16(minute), second: 0, title: todoTitle, memo: todoMemo, storedDate: todoDate, isComplete: false)
            
            return todo
        }
    }
}
