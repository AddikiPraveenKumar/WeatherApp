//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
            NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    idleView
                case .loading:
                    loadingView
                case .loaded(let forecasts, let cityName):
                    forecastView(forecasts: forecasts, cityName: cityName)
                case .error(let error):
                    ErrorView(message: error.localizedDescription)
                }
            }
            .navigationTitle("Weather Forecast")
            .background(.blue.opacity(0.2))
            .onAppear {
                if case .idle = viewModel.state {
                    viewModel.test = "="
                    viewModel.fetchWeather()
                }
            }
        }
    }
    
    private var idleView: some View {
        VStack {
            Text("Weather Forecast")
                .font(.title)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .scaleEffect(2.0)
            
            VStack(spacing: 8) {
                Text("Fetching Weather Data")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("Please wait while we get the latest forecast")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
    }
    
    private func forecastView(forecasts: [WeatherForecast], cityName: String) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                Text(cityName)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                LazyVStack(spacing: 12) {
                    ForEach(forecasts) { forecast in
                        ForecastRow(forecast: forecast)
                    }
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview("Loaded") {
    let viewModel = WeatherViewModel()
    viewModel.state = .loaded([WeatherForecast.mock], "London, UK")
    return WeatherView(viewModel: viewModel)
}
