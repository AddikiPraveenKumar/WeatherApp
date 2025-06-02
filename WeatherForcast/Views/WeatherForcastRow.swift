//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import SwiftUI

struct ForecastRow: View {
    let forecast: WeatherForecast?
    var isLoading: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Date Column
            dateColumn
            
            // Weather Condition
            weatherConditionColumn
            
            Spacer()
            
            // Temperature
            temperatureColumn
        }
        .padding()
        .background(weatherCardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
        .opacity(isLoading ? 0.6 : 1.0)
    }
    
    private var dateColumn: some View {
        VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(forecast?.date.dayOfWeek ?? "")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                    Text(forecast?.date.formattedShortDate ?? "")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.bottom)
            
                Text(forecast?.date.formattedTime ?? "")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
        }
        .frame(width: 120, alignment: .leading)
    }
    
    private var weatherConditionColumn: some View {
        VStack(spacing: 4) {
                Image(systemName: forecast?.weather.first?.iconName ?? "questionmark")
                    .font(.system(size: 28))
                    .foregroundColor(weatherIconColor)

                Text(forecast?.weather.first?.main ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
        }
        .frame(width: 80)
    }
    
    private var temperatureColumn: some View {
        VStack(alignment: .trailing, spacing: 4) {
                Text("\(forecast?.main.tempCelsius ?? 0)°")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
            
            HStack(spacing: 8) {
                    Text("H:\(forecast?.main.maxTempCelsius ?? 0)°")
                        .font(.system(size: 14, weight: .semibold))
                    Text("L:\(forecast?.main.minTempCelsius ?? 0)°")
                        .font(.system(size: 14))

            }
            .foregroundColor(.black)
        }
        .frame(width: 100, alignment: .trailing)
    }
    
    private var weatherCardBackground: some View {
        Color.white
            .cornerRadius(12)
    }
    
    private var weatherIconColor: Color {
        guard let icon = forecast?.weather.first?.icon else { return .white }
        
        switch icon {
        case "01d": return .yellow       // Clear sky (day)
        case "01n": return .black        // Clear sky (night)
        case "02d", "03d", "04d": return .orange  // Few/scattered clouds (day)
        case "02n", "03n", "04n": return .gray   // Few/scattered clouds (night)
        case "09d", "09n", "10d", "10n": return .blue  // Rain
        case "11d", "11n": return .purple        // Thunderstorm
        case "13d", "13n": return .white        // Snow
        case "50d", "50n": return .gray         // Mist
        default: return .white
        }
    }
}


// Preview with loading state
struct ForecastRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForecastRow(forecast: WeatherForecast.mock)
            ForecastRow(forecast: nil, isLoading: true)
        }
    }
}


