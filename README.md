# Weather App

## Description
A cross-platform weather application built with Flutter. It displays current weather conditions and forecasts for the user's current location as well as manually searched cities, with dynamic visuals that adapt to weather conditions and time of day.

This project was developed between November 2024 and January 2025 as part of my Software Engineering Bachelor's degree at the University of Europe for Applied Sciences, Potsdam.

## Features
- **Current Location Weather:** Automatically detects the user's location and fetches live weather data using the device's GPS.
- **City Search:** Allows users to search and view weather forecasts for any city worldwide.
- **Bookmarks:** Users can save and quickly access their favourite cities via a dedicated bookmarks page.
- **Dynamic Visuals:** Background imagery changes based on weather condition (Sunny, Rainy, Snowy, Cloudy, Night).
- **Settings:** Configurable app preferences stored locally using shared preferences.

## Tech Stack
- **Framework:** Flutter (Dart)
- **API:** OpenWeatherMap REST API (`http` package)
- **State Management:** Provider
- **Location Services:** `geolocator`, `geocoding`
- **Local Storage:** `shared_preferences`
- **Utilities:** `intl` (date formatting), `timezone`, `uuid`

## Project Structure
``` 
lib/
├── main.dart # App entry point
├── navigation.dart # Bottom navigation logic
├── home_page.dart # Main weather display screen
├── bookmarks_page.dart # Saved cities screen
├── settings_page.dart # App settings screen
└── utils.dart # Shared utility functions
``` 

## Prerequisites
- Flutter SDK `>=3.3.2 <4.0.0`
- An OpenWeatherMap API key

## Getting Started
1. Clone the repository:
   ```bash
   git clone https://github.com/omar0176/weather.git
   cd weather
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Add your OpenWeatherMap API key to the appropriate configuration file.
4. Run the app:
   ```bash
   flutter run
   ```

## Authors
**Omar Khamis**  
B.Sc. Software Engineering Student  
University of Europe for Applied Sciences, Potsdam

**Sebastian Zelaya**  
B.Sc. Software Design Student  
TH Aschaffenburg
