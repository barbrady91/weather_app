# weather_app

A new Flutter project for displaying weather data from tomorrow.io

## Getting Started

This app was implemented with the following configuration:
```
Flutter 3.24.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 2663184aa7 (7 weeks ago) • 2024-09-11 16:27:48 -0500
Engine • revision 36335019a8
Tools • Dart 3.5.3 • DevTools 2.37.3
```
Upgrade flutter if necessary.

The following steps are necessary to run the app:

1. run ```flutter pub get``` do fetch all packages.
2. next run ```dart run build_runner build -d``` to generate files for serialization and mocking.
3. replace _apiKey in "lib/feature/weather/model/weather_model.dart" with your own key from https://app.tomorrow.io/development/keys.
