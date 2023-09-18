//
//  UserdefaultManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/24.
//

import Foundation

struct UserDefaultManager {
    static let repositoryKey = "GitFullName"
    static let themeKey = "ThemeKey"
    
    private let userDefault: UserDefaults = {
        guard let userDefault = UserDefaults(suiteName: "group.Gitodo") else {
            fatalError("Invalid group in userdefaults")
        }
        
        return userDefault
    }()
    
    func saveRepos(_ dict: [String: Date], _ key: String) {
        userDefault.setValue(dict, forKey: key)
    }
    
    func saveColorKey(_ value: String, _ key: String) {
        userDefault.setValue(value, forKey: key)
    }
    
    func fetchRepos(by key: String) -> [String: Date] {
        guard let dict = userDefault.object(forKey: key) as? [String: Date] else {
            return [:]
        }
        
        return dict
    }
    
    func fetchColorKey(by key: String) -> String {
        guard let colorKey = userDefault.object(forKey: key) as? String else {
            return ""
        }
        
        return colorKey
    }
    
    func delete(by key: String) {
        userDefault.removeObject(forKey: key)
    }
}
