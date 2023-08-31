//
//  UserdefaultManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

struct UserDefaultManager {
    static let repositoryKey = "GitFullName"
    static let lastSavedDateKey = "LastSavedDate"
    
    private let userDefault = UserDefaults.standard
    
    func save(_ arr: [String], _ key: String) {
        userDefault.setValue(arr, forKey: key)
    }
    
    func save(_ date: Date, _ key: String) {
        userDefault.setValue(date, forKey: key)
    }
    
    func fetchRepos(by key: String) -> [String] {
        guard let arr = userDefault.array(forKey: key) as? [String] else {
            return []
        }
        
        return arr
    }
    
    func fetchDate(by key: String) -> Date? {
        guard let date = userDefault.object(forKey: key) as? Date else {
            return nil
        }
        
        return date
    }
    
    func delete(by key: String) {
        userDefault.removeObject(forKey: key)
    }
}
