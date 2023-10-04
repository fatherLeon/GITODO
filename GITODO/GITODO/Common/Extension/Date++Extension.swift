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
    
    private static let iso8601DateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    
    static func toString(_ date: Date) -> String {
        return Date.dateFormatter.string(from: date)
    }
    
    static func toISO8601Date(_ text: String) -> Date? {
        return iso8601DateFormatter.date(from: text)
    }
    
    static func toISO8601String(_ date: Date) -> String {
        return iso8601DateFormatter.string(from: date)
    }
    
    var beforeOneYear: Date? {
        let before = Calendar.current.date(byAdding: .month, value: -12, to: self)
        
        return before
    }
    
    var yesterDay: Date? {
        let before = Calendar.current.date(byAdding: .day, value: -1, to: self)
        
        return before
    }
    
    func convertDateToYearMonthDay() -> (year: Int, month: Int, day: Int)? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else { return nil }
        
        return (year, month, day)
    }
    
    func convertDateToHourMinute() -> (hour: Int, minute: Int)? {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        
        guard let hour = components.hour,
              let minute = components.minute else { return nil }
        
        return (hour, minute)
    }
    
    func isSameDay(by comparedDate: Date) -> Bool {
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let comparedDateComponent = Calendar.current.dateComponents([.year, .month, .day], from: comparedDate)
        
        if dateComponent.year == comparedDateComponent.year &&
            dateComponent.month == comparedDateComponent.month &&
            dateComponent.day == comparedDateComponent.day {
            return true
        } else {
            return false
        }
    }
    
    static func convertDate(year: Int16, month: Int16, day: Int16, hour: Int16, minute: Int16) -> Date {
        let components = DateComponents(year: Int(year), month: Int(month), day: Int(day), hour: Int(hour), minute: Int(minute))
        
        guard let date = components.date else { return Date() }
        
        return date
    }
}
