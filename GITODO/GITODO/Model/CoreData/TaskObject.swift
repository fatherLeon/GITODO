//
//  TaskObject.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/14.
//

import Foundation

struct TaskObject: Interactionable {
    var entityName: String = "Task"
    
    let year: Int
    let month: Int
    let day: Int
    let isCommit: Bool
    
    var id: String {
        return "\(year)-\(month)-\(day)"
    }
}
