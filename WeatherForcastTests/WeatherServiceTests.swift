//
//  WeatherServiceTests.swift
//  WeatherForcastTests
//
//  Created by Praveen UK on 5/29/25.
//

//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import XCTest
import Combine
@testable import WeatherForcast

final class WeatherServiceTests: XCTestCase {
    var weatherService = WeatherService.shared
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
    }
    
    func testFetchWeatherSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather completes")
        let mockCity = "London"
        
        // When
        weatherService.fetchWeather(for: mockCity)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Request should succeed")
                }
                expectation.fulfill()
            }, receiveValue: { response in
                // Then
                XCTAssertFalse(response.list.isEmpty)
                XCTAssertNotNil(response.city.name)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchWeatherInvalidCity() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather fails")
        let invalidCity = "InvalidCityName123"
        
        // When
        weatherService.fetchWeather(for: invalidCity)
            .sink(receiveCompletion: { completion in
                // Then
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, WeatherError.cityNotFound.localizedDescription)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchWeatherInvalidURL() {
        // Given
        let expectation = XCTestExpectation(description: "Invalid URL fails")
        weatherService = WeatherService() // Create new instance to override baseURL
        
        // When
        weatherService.fetchWeather(for: "")
            .sink(receiveCompletion: { completion in
                // Then
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, WeatherError.invalidURL.localizedDescription)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testInvalidURLErrorDescription() {
        let error = WeatherError.invalidURL
        XCTAssertEqual(error.errorDescription, "Unknown server response: HTTP 400")
    }
    
    func testInvalidResponseErrorDescription() {
        let error = WeatherError.invalidResponse
        XCTAssertEqual(error.errorDescription, "Invalid response from server")
    }
    
    func testInvalidAPIKeyErrorDescription() {
        let error = WeatherError.invalidAPIKey
        XCTAssertEqual(error.errorDescription, "Invalid API key - please check your OpenWeather API key")
    }
    
    func testCityNotFoundErrorDescription() {
        let error = WeatherError.cityNotFound
        XCTAssertEqual(error.errorDescription, "City not found - please try another location")
    }
    
}
