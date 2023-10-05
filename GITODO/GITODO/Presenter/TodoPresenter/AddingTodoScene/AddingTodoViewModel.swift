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
    
    init(targetDate: Date, todoObject: TodoObject?) {
        self.targetDate = targetDate
        self.todoObject = todoObject
    }
}
