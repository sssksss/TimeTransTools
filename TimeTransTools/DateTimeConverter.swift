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

// 扩展DateTimeConverter添加天计数和毫秒计数转换功能
extension DateTimeConverter {
    // 日期转换为天计数（从参考日期开始的天数）
    static func dateStringToDayCount(_ dateString: String, referenceDate: Date? = nil) -> Int? {
        guard let date = dateFormatter().date(from: dateString) else {
            return nil
        }
        
        let referenceDate = referenceDate ?? Date(timeIntervalSince1970: 0)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: referenceDate, to: date)
        return components.day
    }
    
    // 天计数转换为日期
    static func dayCountToDateString(_ dayCount: Int, referenceDate: Date? = nil) -> String {
        let referenceDate = referenceDate ?? Date(timeIntervalSince1970: 0)
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .day, value: dayCount, to: referenceDate) else {
            return "无效天数"
        }
        
        return dateFormatter().string(from: date)
    }
    
    // 日期转换为毫秒计数
    static func dateStringToMilliseconds(_ dateString: String, referenceDate: Date? = nil) -> Int64? {
        guard let date = dateFormatter().date(from: dateString) else {
            return nil
        }
        
        if let referenceDate = referenceDate {
            let timeInterval = date.timeIntervalSince(referenceDate)
            return Int64(timeInterval * 1000)
        } else {
            return Int64(date.timeIntervalSince1970 * 1000)
        }
    }
    
    // 毫秒计数转换为日期
    static func millisecondsToDateString(_ milliseconds: Int64, referenceDate: Date? = nil) -> String {
        let seconds = Double(milliseconds) / 1000.0
        
        if let referenceDate = referenceDate {
            let date = referenceDate.addingTimeInterval(seconds)
            return dateFormatter().string(from: date)
        } else {
            let date = Date(timeIntervalSince1970: seconds)
            return dateFormatter().string(from: date)
        }
    }
    
    // 获取当前毫秒时间戳
    static func currentMillisecondTimestamp() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    // 创建一个公共的DateFormatter供内部使用
    private static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sss"
        return formatter
    }
} 