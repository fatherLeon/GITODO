//
//  TodoObject.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/11.
//

import CoreData
import Foundation

struct TodoObject: Interactionable {
    let entityName: String = "Todo"
    
    let commitNum: Int
    let date: Date
    
    var tasks: [TaskObject] = []
}
