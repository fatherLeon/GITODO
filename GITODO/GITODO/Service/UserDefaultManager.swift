//
//  UserdefaultManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

struct UserDefaultManager {
    static let key = "GitFullName"
    
    private let userDefault = UserDefaults.standard
    
    func save(_ arr: [String], _ key: String) {
        userDefault.setValue(arr, forKey: key)
    }
    
    func fetch(by key: String) -> [String] {
        guard let arr = userDefault.array(forKey: key) as? [String] else {
            return []
        }
        
        return arr
    }
    
    func delete(by key: String) {
        userDefault.removeObject(forKey: key)
    }
}
