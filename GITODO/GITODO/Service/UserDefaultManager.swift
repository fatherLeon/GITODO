//
//  UserdefaultManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

struct UserDefaultManager {
    static let repositoryKey = "GitFullName"
    
    private let userDefault = UserDefaults.standard
    
    func save(_ dict: [String: Date], _ key: String) {
        userDefault.setValue(dict, forKey: key)
    }
    
    func fetch(by key: String) -> [String: Date] {
        guard let dict = userDefault.object(forKey: key) as? [String: Date] else {
            return [:]
        }
        
        return dict
    }
    
    func delete(by key: String) {
        userDefault.removeObject(forKey: key)
    }
}
