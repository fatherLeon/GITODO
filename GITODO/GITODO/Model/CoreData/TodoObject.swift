//
//  TodoObject.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/14.
//

import Foundation

struct TodoObject: Interactionable {
    var entityName: String = "Todo"
    
    let hour: Int
    let minute: Int
    let title: String
    let memo: String
}
