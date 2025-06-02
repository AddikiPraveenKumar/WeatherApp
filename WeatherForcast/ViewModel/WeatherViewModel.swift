//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import Foundation
import Combine

/// Represents the different states of the weather data loading process
enum State: Equatable {
    static func == (lhs: State, rhs: State) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded( _,  _), .loaded(_,  _)):
            return true
        case (.error(_), .error(_)):
            return true
        default:
            return true
        }
    }
    case idle
    case loading
    case loaded([WeatherForecast], String)
    case error(WeatherError)
}

/// ViewModel responsible for managing weather data and state
internal class WeatherViewModel: ObservableObject {
    
    @Published var state: State = .idle
    private var weatherService: WeatherServiceProtocal
    private var cancellables = Set<AnyCancellable>()
    var test = ""
    
    init(weatherService: WeatherServiceProtocal =  WeatherService.shared) {
        self.weatherService = weatherService
    }
    /// Fetches weather data for a specified city
    /// - Parameter city: City name (defaults to "London")
    func fetchWeather(for city: String = "London") {
        state = .loading
        
        weatherService.fetchWeather(for: city)
            .sink(receiveCompletion: { [weak self] completion in
                // Handle completion (success or failure)
                if case .failure(let error) = completion {
                    self?.state = .error(error)
                }
            },receiveValue: { [weak self] response in // Handle successful value reception
                self?.state = .loaded(response.list, "\(response.city.name), \(response.city.country)")
            })
            .store(in: &cancellables)
    }
}

