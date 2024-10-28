import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/feature/weather/data/city_data.dart';
import 'package:weather_app/feature/weather/data/weather_data.dart';
import 'package:weather_app/feature/weather/model/city_model.dart';
import 'package:weather_app/feature/weather/model/weather_model.dart';
import 'package:weather_app/feature/weather/view_model/weather_view_model.dart';

@GenerateNiceMocks([MockSpec<WeatherModel>()])
import 'weather_view_model_test.mocks.dart';

void main() {
  late WeatherViewModel viewModel;
  final cityModel = CityModel();
  late MockWeatherModel mockWeatherModel;
  final weatherValues = WeatherValues(
    temperatureAvg: 15.5,
    temperatureMax: 20.2,
    temperatureMin: 10.1,
    humidityAvg: 88.6,
    pressureSurfaceLevelAvg: 960.3,
    windSpeedAvg: 2.8,
  );
  final weatherData1 = WeatherData(
    time: DateTime(2024, 10, 27),
    values: weatherValues,
  );
  final weatherData2 = WeatherData(
    time: DateTime(2024, 10, 28),
    values: weatherValues,
  );
  final weatherDataList = [
    weatherData1,
    weatherData2,
  ];

  final cityDataList = cityModel.fetchData();

  setUp(() {
    mockWeatherModel = MockWeatherModel();
    viewModel = WeatherViewModel(
      cityModel: cityModel,
      weatherModel: mockWeatherModel,
    );
  });

  group('WeatherViewModel', () {
    test('initial status should be loading', () {
      expect(viewModel.status, isA<WeatherViewModelLoadingStatus>());
    });

    test('after initialize was called cities and weather data should be loaded.', () async {
      // Arrange
      final cityData = cityDataList.first;
      final weatherData = weatherDataList.first;
      when(mockWeatherModel.fetchData(
        latitude: cityData.latitude,
        longitude: cityData.longitude,
      )).thenAnswer(
        (_) async => weatherDataList,
      );

      // Act
      await viewModel.initialize();

      // Assert
      expect(viewModel.status, isA<WeatherViewModelLoadedStatus>());
      final status = viewModel.status as WeatherViewModelLoadedStatus;
      expect(status.selectedCityData.name, equals(cityData.name));
      expect(status.cityDataList.length, equals(cityDataList.length));
      expect(status.cityDataList.first.name, equals(cityDataList.first.name));
      expect(status.cityDataList.last.name, equals(cityDataList.last.name));
      expect(status.selectedWeatherData, weatherData);
      expect(status.weatherDataList, equals(weatherDataList));
    });

    test('check if the timer changes the city after one minute.', () async {
      // Arrange
      final cityData1 = cityDataList[0];
      final cityData2 = cityDataList[1];
      when(mockWeatherModel.fetchData(
        latitude: cityData1.latitude,
        longitude: cityData1.longitude,
      )).thenAnswer(
        (_) async => weatherDataList,
      );
      when(mockWeatherModel.fetchData(
        latitude: cityData2.latitude,
        longitude: cityData2.longitude,
      )).thenAnswer(
        (_) async => weatherDataList,
      );

      // Act
      await viewModel.initialize();
      await Future.delayed(const Duration(seconds: 65));

      // Assert
      expect(viewModel.status, isA<WeatherViewModelLoadedStatus>());
      final status = viewModel.status as WeatherViewModelLoadedStatus;
      expect(status.selectedCityData.name, equals(cityData2.name));
    }, timeout: const Timeout(Duration(seconds: 70)));

    //todo: check timer?

    test('refreshWeatherData should load weather data for a given city', () async {
      // Arrange
      final cityData = cityDataList.first;
      final weatherData = weatherDataList.first;
      when(mockWeatherModel.fetchData(
        latitude: cityData.latitude,
        longitude: cityData.longitude,
      )).thenAnswer(
        (_) async => weatherDataList,
      );

      // Act
      await viewModel.refreshWeatherData(
        cityData: cityData,
        cityDataList: cityDataList,
        setLoadingStatus: true,
      );

      // Assert
      expect(viewModel.status, isA<WeatherViewModelLoadedStatus>());
      final status = viewModel.status as WeatherViewModelLoadedStatus;
      expect(status.selectedCityData, equals(cityData));
      expect(status.cityDataList, equals(cityDataList));
      expect(status.selectedWeatherData, weatherData);
      expect(status.weatherDataList, equals(weatherDataList));
    });

    test('refreshWeatherData should set error status if loading weather data fails', () async {
      // Arrange
      final cityData = CityData(name: 'Berlin', latitude: 52.520008, longitude: 13.404954);
      when(mockWeatherModel.fetchData(
        latitude: cityData.latitude,
        longitude: cityData.longitude,
      )).thenThrow(
        Exception('Failed to load weather'),
      );

      // Act
      await viewModel.refreshWeatherData(
        cityData: cityData,
        cityDataList: cityDataList,
        setLoadingStatus: true,
      );

      // Assert
      expect(viewModel.status, isA<WeatherViewModelErrorStatus>());
    });

    test('selectWeatherData should set the given weather data.', () async {
      // Arrange
      final oldStatus = WeatherViewModelLoadedStatus(
        selectedCityData: cityDataList.first,
        cityDataList: cityDataList,
        selectedWeatherData: weatherData1,
        weatherDataList: weatherDataList,
      );

      // Act
      viewModel.selectWeatherData(weatherData2, oldStatus);

      // Assert
      expect(viewModel.status, isA<WeatherViewModelLoadedStatus>());
      final newStatus = viewModel.status as WeatherViewModelLoadedStatus;
      expect(newStatus.selectedWeatherData, weatherData2);
    });

    test('selectCityData should set the given city and load new weather data.', () async {
      // Arrange
      final newCityData = cityDataList.last;
      when(mockWeatherModel.fetchData(
        latitude: newCityData.latitude,
        longitude: newCityData.longitude,
      )).thenAnswer(
        (_) async => weatherDataList,
      );

      final oldStatus = WeatherViewModelLoadedStatus(
        selectedCityData: cityDataList.first,
        cityDataList: cityDataList,
        selectedWeatherData: weatherData1,
        weatherDataList: weatherDataList,
      );

      // Act
      await viewModel.selectCityData(newCityData, oldStatus);

      // Assert
      expect(viewModel.status, isA<WeatherViewModelLoadedStatus>());
      final newStatus = viewModel.status as WeatherViewModelLoadedStatus;
      expect(newStatus.selectedCityData, newCityData);
    });
  });
}
