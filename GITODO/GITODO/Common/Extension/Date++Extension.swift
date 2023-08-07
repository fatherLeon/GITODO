//
//  Date++Extension.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/07.
//

import Foundation

extension Date {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "YYYY-MM"
        formatter.locale = Locale.current
        
        return formatter
    }()
    
    static func toString(_ date: Date) -> String {
        return Date.dateFormatter.string(from: date)
    }
}
