//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import Foundation

extension Date {
    // Returns the day of week as a 3-letter abbreviation (e.g., "Mon", "Tue")
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // "EEE" format for short weekday name
        return formatter.string(from: self)
    }
    
    // Returns time in 12-hour format with AM/PM (e.g., "2:30 PM")
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // "h"=12-hour, "mm"=minutes, "a"=AM/PM
        return formatter.string(from: self)
    }
    // Returns date in abbreviated month and day format (e.g., "May 29")
    var formattedShortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // "MMM"=short month, "d"=day without leading zero
        return formatter.string(from: self)
    }
}
