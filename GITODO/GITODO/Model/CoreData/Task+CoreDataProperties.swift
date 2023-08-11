//
//  Task+CoreDataProperties.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/11.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isCommit: Bool
    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for todos
extension Task {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: Task)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: Task)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}

extension Task : Identifiable {

}
