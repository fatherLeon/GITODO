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
    var isWritingCompleted: Observable<Bool> {
        return todoTitleText
            .map { title in
                return title.isEmpty == false
            }
    }
    
    init(targetDate: Date, todoObject: TodoObject?) {
        self.targetDate = targetDate
        self.todoObject = todoObject
    }
    
    func processTodo() -> Bool {
        if headTextField.text == "" || headTextField.text == nil {
            showAlert(title: "할 일을 입력해주세요", message: nil)
            return
        }
        
        var result = true
        
        if todoObject == nil {
            result = save()
        } else {
            result = update()
        }
        
        if result {
            delegate?.updateTableView(by: datePicker.date)
            self.dismiss(animated: true)
        }
    }
    
    private func save() -> Bool {
        guard let todo = makeTodoObject() else { return false }
        
        do {
            try coredataManager.save(todo)
            return true
        } catch {
            showAlert(title: "저장 실패", message: nil)
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
            showAlert(title: "업데이트 실패", message: nil)
            return false
        }
    }
    
    private func makeTodoObject() -> TodoObject? {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: datePicker.date)
        guard let year = components.year,
              let month = components.month,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute,
              let second = components.second else { return nil }
        
        let todo = TodoObject(year: Int16(year), month: Int16(month), day: Int16(day), hour: Int16(hour), minute: Int16(minute), second: Int16(second), title: headTextField.text!, memo: contentTextView.text, storedDate: Date(), isComplete: false)
        
        return todo
    }
}
