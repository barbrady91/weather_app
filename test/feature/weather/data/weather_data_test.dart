import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/feature/weather/data/weather_data.dart';

void main() {
  group('WeatherData', () {
    test('fromJson should create a WeatherData object.', () {
      // Arrange
      const time = '2024-10-23T04:00:00Z';
      const temperatureAvg = 15.5;
      const temperatureMax = 20.2;
      const temperatureMin = 10.1;
      const humidityAvg = 88.6;
      const pressureSurfaceLevelAvg = 960.3;
      const windSpeedAvg = 2.8;

      final json = {
        'time': time,
        'values': {
          'temperatureAvg': temperatureAvg,
          'temperatureMax': temperatureMax,
          'temperatureMin': temperatureMin,
          'humidityAvg': humidityAvg,
          'pressureSurfaceLevelAvg': pressureSurfaceLevelAvg,
          'windSpeedAvg': windSpeedAvg,
        },
      };

      // Act
      final weatherData = WeatherData.fromJson(json);

      // Assert
      expect(weatherData, isA<WeatherData>());
      expect(weatherData, isNotNull);
      expect(weatherData.time.compareTo(DateTime.parse(time)), 0);
      expect(weatherData.values.temperatureAvg, temperatureAvg);
      expect(weatherData.values.temperatureMax, temperatureMax);
      expect(weatherData.values.temperatureMin, temperatureMin);
      expect(weatherData.values.humidityAvg, humidityAvg);
      expect(weatherData.values.pressureSurfaceLevelAvg, pressureSurfaceLevelAvg);
      expect(weatherData.values.windSpeedAvg, windSpeedAvg);
    });
  });
}
