//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import XCTest
import Combine
@testable import WeatherForcast

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockService: MockWeatherService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockService = nil
    }
    
    func testInitialStateIsIdle() {
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func testFetchWeatherSuccess() {
        let expectation = XCTestExpectation(description: "State becomes loaded")
        viewModel.$state
            .dropFirst() // Skip initial idle state
            .sink { state in
                print(state)
                if case .loaded(let forecasts, let cityName) = state {
                    XCTAssertEqual(forecasts.count, 10)
                    XCTAssertEqual(cityName, "London, UK")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchWeather()
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testFetchWeatherFailure() {
        let expectation = XCTestExpectation(description: "State becomes error")
        mockService.shouldFail = true
        mockService.mockError = WeatherError.cityNotFound
        
        viewModel.$state
            .dropFirst() // Skip initial idle state
            .sink { state in
                if case .error(let error) = state {
                    XCTAssertEqual(error.localizedDescription, "City not found - please try another location")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchWeather()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testIdleEquality() {
        let idle1 = State.idle
        let idle2 = State.idle
        XCTAssertEqual(idle1, idle2)
    }
    
    func testLoadingEquality() {
        let loading1 = State.loading
        let loading2 = State.loading
        XCTAssertEqual(loading1, loading2)
    }
    
    func testLoadedEquality() {
        let forecast1 = [WeatherForecast]() // Add sample data
        let forecast2 = [WeatherForecast]() // Add same sample data
        let cityName1 = "London"
        let cityName2 = "London"
        
        let loaded1 = State.loaded(forecast1, cityName1)
        let loaded2 = State.loaded(forecast2, cityName2)
        XCTAssertEqual(loaded1, loaded2)
    }
    
    func testErrorEquality() {
        let error1 = WeatherError.invalidURL
        let error2 = WeatherError.invalidURL
        
        let state1 = State.error(error1)
        let state2 = State.error(error2)
        XCTAssertEqual(state1, state2)
    }
}

// MARK: - Mock Weather Service
class MockWeatherService: WeatherServiceProtocal {
    var mockResponse: WeatherResponse = .mock
    var mockError: WeatherError = .cityNotFound
    var shouldFail = false
    var isLoading = false
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, WeatherError> {
        if shouldFail {
            return Fail(error: mockError).eraseToAnyPublisher()
        } else {
            return Just(mockResponse)
                .setFailureType(to: WeatherError.self)
                .eraseToAnyPublisher()
        }
    }
}

