//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import Foundation

// Top-level response structure for weather API
struct WeatherResponse: Codable {
    let list: [WeatherForecast]
    let city: City
}

// Represents a single weather forecast data point
struct WeatherForecast: Codable, Identifiable {
    let id = UUID()
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]

    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather
    }
    
    var date: Date {
        Date(timeIntervalSince1970: dt)
    }
}
// Contains temperature-related weather data
struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    
    // Current temperature in Celsius (rounded)
    var tempCelsius: Int {
        Int(temp)
    }
    
    var minTempCelsius: Int {
        Int(temp_min)
    }
    
    var maxTempCelsius: Int {
        Int(temp_max)
    }
}
// Describes weather conditions
struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
    
    var iconName: String {
        switch icon {
        case "01d": return "sun.max"
        case "01n": return "moon"
        case "02d": return "cloud.sun"
        case "02n": return "cloud.moon"
        case "03d", "03n", "04d", "04n": return "cloud"
        case "09d", "09n": return "cloud.rain"
        case "10d": return "cloud.sun.rain"
        case "10n": return "cloud.moon.rain"
        case "11d", "11n": return "cloud.bolt"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog"
        default: return "questionmark"
        }
    }
}
// Represents city information
struct City: Codable {
    let name: String
    let country: String
}

// MARK: - Mock Data Extensions
// These extensions provide sample data for previews and testing
extension WeatherForecast {
    static var mock: WeatherForecast {
        WeatherForecast(
            dt: Date().timeIntervalSince1970,
            main: Main(
                temp: 20,
                temp_min: 20,
                temp_max: 25
            ),
            weather: [
                Weather(
                    main: "Clouds",
                    description: "scattered clouds",
                    icon: "03d"
                )
            ]
        )
    }
}

// Provides mock API response data for development/testing
extension WeatherResponse {
    static var mock: WeatherResponse {
        WeatherResponse(
            list: Array(repeating: WeatherForecast.mock, count: 10),
            city: City(name: "London", country: "UK")
        )
    }
}
