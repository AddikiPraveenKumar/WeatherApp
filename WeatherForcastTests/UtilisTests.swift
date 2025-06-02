//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import XCTest
import Combine
@testable import WeatherForcast

class UtilisTests: XCTestCase {
    var date: Date {
        let isoDate = "2025-05-29 09:00:00"

          let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from:isoDate)!
    }
    
    func testDayofWeek() {
        XCTAssertEqual(date.dayOfWeek, "Thu")
        XCTAssertEqual(date.formattedTime, "9:00 AM")
        XCTAssertEqual(date.formattedShortDate, "May 29")
    }
}

