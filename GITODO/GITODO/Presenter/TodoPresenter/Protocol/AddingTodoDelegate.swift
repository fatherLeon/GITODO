//
//  AddingTodoDelegate.swift
//  GITODO
//
//  Created by 강민수 on 2023/10/05.
//

import Foundation

protocol AddingTodoDelegate: AnyObject {
    func updateTableView(by date: Date)
}
