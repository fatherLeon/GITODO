//
//  UserdefaultManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

struct UserDefaultManager {
    private let userDefault = UserDefaults.standard
    
    func save(_ dict: [String: String], _ key: String) {
        userDefault.setValue(dict, forKey: key)
    }
    
    func fetch(by key: String) -> [String: Any] {
        guard let dict = userDefault.dictionary(forKey: key) else {
            return [:]
        }
        
        return dict
    }
    
    func update(_ dict: [String: String], _ key: String) {
        var data = fetch(by: key)
        
        for (label, value) in dict {
            data[label] = value
        }
        
        userDefault.setValue(data, forKey: key)
    }
    
    func delete(by key: String) {
        userDefault.removeObject(forKey: key)
    }
}
