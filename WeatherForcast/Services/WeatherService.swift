//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import Foundation
import Combine

// Protocol defining the weather service interface for dependency injection and testing
protocol WeatherServiceProtocal {
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, WeatherError>
}

// Service class for handling weather data fetching from OpenWeather API
class WeatherService: WeatherServiceProtocal {
    static let shared = WeatherService()
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
    
    /// Fetches weather forecast data for a specified city
    /// - Parameter city: City name (defaults to "London")
    /// - Returns: Publisher that emits either WeatherResponse or WeatherError
    func fetchWeather(for city: String = "London") -> AnyPublisher<WeatherResponse, WeatherError> {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPIKey") as? String else {
            fatalError("API Key not found")
        }
        guard let url = URL(string: "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw WeatherError.invalidResponse
                }
                switch httpResponse.statusCode {
                case 200:
                    return data
                case 401:
                    throw WeatherError.invalidAPIKey
                case 404:
                    throw WeatherError.cityNotFound
                case 500:
                    throw WeatherError.serverError
                default:
                    throw WeatherError.unknown(statusCode: httpResponse.statusCode)
                }
            }
        // Decode JSON response into WeatherResponse model
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
        // Convert any errors to WeatherError type
            .mapError { error in
                if let weatherError = error as? WeatherError {
                    return weatherError
                } else if let decodingError = error as? DecodingError {
                    return WeatherError.decodingError(description: decodingError.localizedDescription)
                } else {
                    return WeatherError.unknownError(error: error)
                }
            }
        // Ensure reception on main thread for UI updates
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

/// Custom error type for weather service operations
enum WeatherError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidAPIKey
    case cityNotFound
    case serverError
    case decodingError(description: String)
    case unknownError(error: Error)
    case unknown(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unknown server response: HTTP 400"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidAPIKey:
            return "Invalid API key - please check your OpenWeather API key"
        case .cityNotFound:
            return "City not found - please try another location"
        case .serverError:
            return "Server error - please try again later"
        case .decodingError(let description):
            return "Failed to decode weather data: \(description)"
        case .unknownError(let error):
            return "Unknown error: \(error.localizedDescription)"
        case .unknown(let statusCode):
            return "Unknown server response: HTTP \(statusCode)"
        }
    }
}
