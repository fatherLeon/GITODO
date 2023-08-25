//
//  Interactionable.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/25.
//

import CoreData
import Foundation

protocol Interactionable {
    var id: String { get set }
    var storedDate: Date { get set }
    static var entityType: NSManagedObject.Type { get set }
    static var entityName: String { get set }
    
    func transform() -> NSManagedObject
    static func transform(_ data: NSManagedObject) -> Interactionable?
}
