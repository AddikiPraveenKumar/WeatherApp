# Weather Forecast App

A simple iOS app that displays a 5-day weather forecast using OpenWeather API.

## Technical Decisions

1. **SwiftUI**: Chosen for its modern, declarative approach to UI development.
2. **MVVM Architecture**: Provides clear separation of concerns and makes the code more testable.
3. **Combine Framework**: Used for handling asynchronous events and data binding.
4. **Native Networking**: Used URLSession instead of third-party libraries as required.
5. **Error Handling**: Comprehensive error states with user-friendly messages.

## Missing Features & Why

1. **Location Services**: Not implemented to keep focus on core requirements.
   - Could be added with CoreLocation in future.
2. **City Search**: Only shows London by default.
   - Would require additional UI components.
3. **Persistent Storage**: No caching of weather data.
   - Would improve offline experience.
4. **Accessibility**: Not implemented to keep focus on core requirements.
5. **Constant Strings**: Need to move constant strings to constants file, due to time constraint couldn't do it'
6. **UI test cases**: Not implemented to keep focus on core requirements.

## How to Run

1. Build and run the app in Xcode.

## Time Allocation

- API Integration: 1 hour
- UI Implementation: 1 hour
- Error Handling & Polish: 1 hour
- Took Little time on icons to show on the weather condition
- Unit Test cases Handled


