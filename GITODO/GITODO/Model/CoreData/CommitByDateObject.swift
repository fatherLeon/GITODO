//
//  CommitByDateObject.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/25.
//

import CoreData
import Foundation

struct CommitByDateObject: Interactionable {
    static var entityType: NSManagedObject.Type = CommitByDate.self
    static var entityName: String = "CommitByDate"
    
    var id: String
    var storedDate: Date
    let year: Int16
    let month: Int16
    let day: Int16
    var commitedNum: Int64
    
    init(year: Int, month: Int, day: Int, storedDate: Date, commitedNum: Int) {
        self.id = "\(year)-\(month)-\(day)"
        self.storedDate = storedDate
        self.year = Int16(year)
        self.month = Int16(month)
        self.day = Int16(day)
        self.commitedNum = Int64(commitedNum)
    }

    func transform() -> NSManagedObject {
        let commit = CommitByDate()
        
        commit.commitedNum = self.commitedNum
        
        return commit
    }

    static func transform(_ data: NSManagedObject) -> Interactionable? {
        guard let data = data as? CommitByDate,
              let storedDate = data.storedDate else { return nil }
        
        return CommitByDateObject(year: Int(data.year), month: Int(data.month), day: Int(data.day), storedDate: storedDate, commitedNum: Int(data.commitedNum))
    }
}
