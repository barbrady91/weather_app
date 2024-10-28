import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/feature/weather/data/city_data.dart';
import 'package:weather_app/feature/weather/model/city_model.dart';

void main() {
  group('CityModel', () {
    test('fetchData should return a list of five [CityData] objects.', () {
      // Act
      final cityDataList = CityModel().fetchData();

      // Assert
      expect(cityDataList, isA<List<CityData>>());
      expect(cityDataList.length, 5);
      expect(cityDataList.first.name, equals('Munich'));
      expect(cityDataList.last.name, equals('New York'));
    });
  });
}
