//
//  Interactionable.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/11.
//

import CoreData

protocol Interactionable {
    var entityName: String { get }
    
    func getProperties() -> [String: Any]
}

extension Interactionable {
    func getProperties() -> [String: Any] {
        let object = Mirror(reflecting: self)
        var properties: [String: Any] = [:]
        
        for child in object.children {
            properties[child.label ?? ""] = child.value
        }
        
        return properties
    }
}
