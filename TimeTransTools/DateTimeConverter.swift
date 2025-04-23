//
//  DateTimeConverter.swift
//  TimeTransTools
//
//  Created by XWW on 2025/4/23.
//

import Foundation

struct DateTimeConverter {
    
    // 默认时间戳起始时间 - 1970年1月1日
    static let defaultReferenceDate = Date(timeIntervalSince1970: 0)
    
    // 将日期字符串转换为时间戳
    static func dateStringToTimestamp(_ dateString: String, format: String = "yyyy-MM-dd'T'HH:mm:sss") -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        
        return Int(date.timeIntervalSince1970)
    }
    
    // 将时间戳转换为日期字符串
    static func timestampToDateString(_ timestamp: Int, format: String = "yyyy-MM-dd'T'HH:mm:sss") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // 将年、月、日、时、分、秒各个分量转换为时间戳
    static func componentsToTimestamp(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Int? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            return nil
        }
        
        return Int(date.timeIntervalSince1970)
    }
    
    // 从时间戳获取日期分量
    static func timestampToComponents(_ timestamp: Int) -> DateComponents {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }
    
    // 设置自定义参考日期的时间转换
    static func dateStringToCustomTimestamp(_ dateString: String, 
                                           referenceDate: Date = defaultReferenceDate,
                                           format: String = "yyyy-MM-dd'T'HH:mm:sss") -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        
        return Int(date.timeIntervalSince(referenceDate))
    }
    
    // 获取当前系统时间的时间戳
    static func currentTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    // 将时间戳转换为日期字符串，相对于自定义起始时间
    static func timestampToDateStringWithCustomReference(_ timestamp: Int, referenceDate: Date = defaultReferenceDate, format: String = "yyyy-MM-dd'T'HH:mm:sss") -> String {
        let date = referenceDate.addingTimeInterval(TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
} 