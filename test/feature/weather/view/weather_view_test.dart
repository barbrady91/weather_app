import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/feature/weather/data/weather_data.dart';
import 'package:weather_app/feature/weather/model/city_model.dart';
import 'package:weather_app/feature/weather/model/weather_model.dart';
import 'package:weather_app/feature/weather/view/weather_view.dart';
import 'package:weather_app/feature/weather/view_model/weather_view_model.dart';

@GenerateNiceMocks([MockSpec<WeatherModel>()])
import 'weather_view_test.mocks.dart';

void main() {
  final cityModel = CityModel();
  final cityDataList = cityModel.fetchData();
  late MockWeatherModel mockWeatherModel;
  late WeatherViewModel weatherViewModel;
  const sundayTemperatureAvg = 20.6;
  const mondayTemperatureAvg = 10.3;
  final weatherDataSunday = WeatherData(
    time: DateTime(2024, 10, 27),
    values: WeatherValues(
      temperatureAvg: sundayTemperatureAvg,
      temperatureMax: 20.2,
      temperatureMin: 10.1,
      humidityAvg: 88.6,
      pressureSurfaceLevelAvg: 960.3,
      windSpeedAvg: 2.8,
    ),
  );
  final weatherDataMonday = WeatherData(
    time: DateTime(2024, 10, 28),
    values: WeatherValues(
      temperatureAvg: mondayTemperatureAvg,
      temperatureMax: 20.2,
      temperatureMin: 10.1,
      humidityAvg: 88.6,
      pressureSurfaceLevelAvg: 960.3,
      windSpeedAvg: 2.8,
    ),
  );
  final weatherDataList = [
    weatherDataSunday,
    weatherDataMonday,
  ];

  setUp(() {
    mockWeatherModel = MockWeatherModel();
    weatherViewModel = WeatherViewModel(
      cityModel: cityModel,
      weatherModel: mockWeatherModel,
    );
  });

  testWidgets('check if all ui elements work like expected', (WidgetTester tester) async {
    final cityDataFirst = cityDataList.first;
    final cityDataLast = cityDataList.last;
    when(mockWeatherModel.fetchData(
      latitude: cityDataFirst.latitude,
      longitude: cityDataFirst.longitude,
    )).thenAnswer(
      (_) async => weatherDataList,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: WeatherView(
          viewModel: weatherViewModel,
        ),
      ),
    );

    /// Check if the ui starts with a loading status.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Fetching weather data...'), findsOneWidget);

    await tester.pumpAndSettle();

    /// Check if the data of the first city is displayed.
    final finderFirstCity = find.text(cityDataFirst.name);
    expect(find.text('Sunday'), findsOneWidget);
    expect(find.text(sundayTemperatureAvg.round().toString()), findsOneWidget);
    expect(finderFirstCity, findsOneWidget);

    /// Tap on the DropDown-Button.
    await tester.tap(finderFirstCity);

    await tester.pumpAndSettle();

    /// Check if the all cities are displayed.
    final finderLastCity = find.text(cityDataLast.name);
    expect(finderLastCity, findsOneWidget);

    /// Change the city to the last one in the list.
    when(mockWeatherModel.fetchData(
      latitude: cityDataLast.latitude,
      longitude: cityDataLast.longitude,
    )).thenThrow(
      Exception('Failed to load weather'),
    );
    await tester.tap(finderLastCity);
    await tester.pumpAndSettle();

    /// Check if error message and retry button is displayed.
    expect(find.text('Could not fetch weather data.'), findsOneWidget);
    final finderTryAgainButton = find.text('Try again');
    expect(finderTryAgainButton, findsOneWidget);

    /// Check if try again works like expected.
    when(mockWeatherModel.fetchData(
      latitude: cityDataLast.latitude,
      longitude: cityDataLast.longitude,
    )).thenAnswer(
      (_) async => weatherDataList,
    );
    await tester.tap(finderTryAgainButton);
    await tester.pumpAndSettle();

    /// Check if the ui has refreshed to the last city.
    expect(find.text(cityDataLast.name), findsOneWidget);

    /// Select a different day.
    final finderMondayButton = find.text('Mon');
    expect(finderMondayButton, findsOneWidget);
    await tester.tap(finderMondayButton);
    await tester.pumpAndSettle();

    /// Check if monday is now selected and weather data of monday is displayed.
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text(mondayTemperatureAvg.round().toString()), findsOneWidget);
  });
}
