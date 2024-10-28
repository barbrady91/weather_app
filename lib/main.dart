import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/feature/weather/model/city_model.dart';
import 'package:weather_app/feature/weather/model/weather_model.dart';
import 'package:weather_app/feature/weather/view/weather_view.dart';
import 'package:weather_app/feature/weather/view_model/weather_view_model.dart';
import 'package:weather_app/shared/app_theme.dart';

final getIt = GetIt.instance;

void main() {
  runApp(
    WeatherApp(
      cityModel: CityModel(),
      weatherModel: WeatherModel(),
    ),
  );
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({
    super.key,
    required this.cityModel,
    required this.weatherModel,
  });

  final CityModel cityModel;
  final WeatherModel weatherModel;

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late final WeatherViewModel _weatherViewModel;

  @override
  void initState() {
    super.initState();
    _registerSingletons();
    _weatherViewModel = WeatherViewModel(
      cityModel: getIt<CityModel>(),
      weatherModel: getIt<WeatherModel>(),
    );
  }

  void _registerSingletons() {
    getIt.registerSingleton(widget.cityModel);
    getIt.registerSingleton(widget.weatherModel);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: WeatherView(viewModel: _weatherViewModel),
    );
  }
}
