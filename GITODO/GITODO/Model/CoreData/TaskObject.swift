//
//  TaskObject.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/11.
//

import CoreData
import Foundation

struct TaskObject: Interactionable {
    let entityName: String = "Task"
    
    let date: Date
    let memo: String
    let title: String
}
