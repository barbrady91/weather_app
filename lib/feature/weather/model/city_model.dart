import 'package:weather_app/feature/weather/data/city_data.dart';

/// The Model for [CityData] which handles all city related operations.
class CityModel {
  List<CityData> fetchData() {
    return [
      CityData(name: 'Munich', latitude: 48.137154, longitude: 11.576124),
      CityData(name: 'San Francisco', latitude: 37.773972, longitude: -122.431297),
      CityData(name: 'Berlin', latitude: 52.520008, longitude: 13.404954),
      CityData(name: 'Tokyo', latitude: 35.652832, longitude: 139.839478),
      CityData(name: 'New York', latitude: 40.730610, longitude: -73.935242),
    ];
  }
}
