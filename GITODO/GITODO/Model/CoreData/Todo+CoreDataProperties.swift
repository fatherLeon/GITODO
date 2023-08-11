//
//  Todo+CoreDataProperties.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/11.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var title: String?
    @NSManaged public var memo: String?
    @NSManaged public var date: Date?

}

extension Todo : Identifiable {

}
