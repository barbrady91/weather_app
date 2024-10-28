import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/feature/weather/data/weather_data.dart';
import 'package:weather_app/feature/weather/model/weather_model.dart';

void main() {
  group('WeatherModel', () {
    test('fetchData should return a list of [WeatherData] objects.', () async {
      // Act
      final weatherDataList = await WeatherModel().fetchData(
        latitude: 52.520008,
        longitude: 13.404954,
      ); // Berlin

      // Assert
      expect(weatherDataList.length, greaterThanOrEqualTo(6));
      expect(weatherDataList, isA<List<WeatherData>>());
    });
  });
}
