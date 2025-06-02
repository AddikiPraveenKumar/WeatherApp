//
//  WeatherService.swift
//  WeatherForcast
//
//  Created by Praveen UK on 5/30/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            VStack(spacing: 8) {
                Text("Unable to Load Weather")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    ErrorView(message: "Invalid Url")
}
