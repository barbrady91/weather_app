import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/feature/weather/data/city_data.dart';
import 'package:weather_app/feature/weather/data/weather_data.dart';
import 'package:weather_app/feature/weather/model/city_model.dart';
import 'package:weather_app/feature/weather/model/weather_model.dart';

/// This abstract class is the starting point for all statuses.
abstract class WeatherViewModelStatus {}

/// This status indicates that the application is loading.
class WeatherViewModelLoadingStatus extends WeatherViewModelStatus {}

/// This status indicates that an error occurred.
class WeatherViewModelErrorStatus extends WeatherViewModelStatus {
  final CityData selectedCityData;
  final List<CityData> cityDataList;

  WeatherViewModelErrorStatus({
    required this.selectedCityData,
    required this.cityDataList,
  });
}

/// This status indicates that all data could successfully be loaded.
class WeatherViewModelLoadedStatus extends WeatherViewModelStatus {
  final CityData selectedCityData;
  final List<CityData> cityDataList;
  final WeatherData selectedWeatherData;
  final List<WeatherData> weatherDataList;

  WeatherViewModelLoadedStatus({
    required this.selectedCityData,
    required this.cityDataList,
    required this.selectedWeatherData,
    required this.weatherDataList,
  });

  /// Copies the current object and creates a new one with the changed parameters.
  WeatherViewModelLoadedStatus copyWith({
    CityData? selectedCityData,
    List<CityData>? cityDataList,
    WeatherData? selectedWeatherData,
    List<WeatherData>? weatherDataList,
  }) {
    return WeatherViewModelLoadedStatus(
      selectedCityData: selectedCityData ?? this.selectedCityData,
      cityDataList: cityDataList ?? this.cityDataList,
      selectedWeatherData: selectedWeatherData ?? this.selectedWeatherData,
      weatherDataList: weatherDataList ?? this.weatherDataList,
    );
  }
}

/// This is the the weather view model which holds all weather related operations and data.
class WeatherViewModel extends ChangeNotifier {
  Timer? _timer;

  /// The current status of the view model.
  WeatherViewModelStatus get status => _status;
  WeatherViewModelStatus _status = WeatherViewModelLoadingStatus();

  /// This property represents the [CityModel] to handle all city related operations.
  final CityModel cityModel;

  /// This property represents the [WeatherModel] to handle all weather related operations.
  final WeatherModel weatherModel;

  /// This is the the weather view model which holds all weather related operations and data.
  WeatherViewModel({required this.cityModel, required this.weatherModel});

  /// This method allows the user to select [WeatherData] respectively a different day.
  void selectWeatherData(WeatherData weatherData, WeatherViewModelLoadedStatus status) {
    if (weatherData == status.selectedWeatherData) {
      debugPrint('[WeatherViewModel.selectWeatherModel] weatherData is already selected');
      return;
    }
    if (!status.weatherDataList.contains(weatherData)) {
      debugPrint('[WeatherViewModel.selectWeatherModel] unknown weatherData');
      return;
    }
    _status = status.copyWith(selectedWeatherData: weatherData);
    notifyListeners();
  }

  /// This method allows the user to select [CityData] respectively a different city.
  Future<void> selectCityData(CityData cityData, WeatherViewModelLoadedStatus status) async {
    if (cityData == status.selectedCityData) {
      debugPrint('[WeatherViewModel.selectCityData] cityData is already selected');
      return;
    }
    await refreshWeatherData(
      cityData: cityData,
      cityDataList: status.cityDataList,
      setLoadingStatus: true,
    );
  }

  /// This method initializes the view model.
  Future<void> initialize() async {
    final cityDataList = cityModel.fetchData();
    if (cityDataList.isEmpty) {
      debugPrint('[WeatherViewModel.initialize] cityDataList is empty');
      return;
    }
    final cityData = cityDataList.first;
    await refreshWeatherData(
      cityData: cityData,
      cityDataList: cityDataList,
      setLoadingStatus: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      _timerFunction,
    );
  }

  Future<void> _timerFunction(_) async {
    final status = _status;
    if (status is! WeatherViewModelLoadedStatus) {
      debugPrint('[WeatherViewModel._timerFunction] wrong status type ${status.runtimeType}');
      return;
    }
    final cityData = _getNextCityData(status.selectedCityData, status.cityDataList);
    if (cityData == null) {
      debugPrint('[WeatherViewModel._timerFunction] could not find next city');
      return;
    }
    await refreshWeatherData(
      cityData: cityData,
      cityDataList: status.cityDataList,
      setLoadingStatus: true,
    );
  }

  /// This method fetches new [WeatherData] for a given [CityModel].
  ///
  /// With the parameter setLoadingStatus you can specify weather
  /// the [WeatherViewModelLoadingStatus] will be emitted or not.
  ///
  /// Set [oldWeatherData] if the same day should be selected
  /// after refreshing the weather data.
  Future<void> refreshWeatherData({
    required CityData cityData,
    required List<CityData> cityDataList,
    required bool setLoadingStatus,
    WeatherData? oldWeatherData,
  }) async {
    if (setLoadingStatus) {
      _status = WeatherViewModelLoadingStatus();
      notifyListeners();
    }

    List<WeatherData>? weatherDataList;
    try {
      weatherDataList = await weatherModel.fetchData(
        latitude: cityData.latitude,
        longitude: cityData.longitude,
      );
    } catch (error) {
      debugPrint(error.toString());
    }

    if (weatherDataList == null || weatherDataList.isEmpty) {
      _timer?.cancel();
      _status = WeatherViewModelErrorStatus(
        selectedCityData: cityData,
        cityDataList: cityDataList,
      );
      notifyListeners();
      return;
    }

    _startTimer();

    final weatherData = _getWeatherDataOnSameDay(oldWeatherData, weatherDataList) ?? weatherDataList.first;

    _status = WeatherViewModelLoadedStatus(
      selectedCityData: cityData,
      cityDataList: cityDataList,
      selectedWeatherData: weatherData,
      weatherDataList: weatherDataList,
    );
    notifyListeners();
  }

  WeatherData? _getWeatherDataOnSameDay(WeatherData? oldWeatherData, List<WeatherData> newWeatherDataList) {
    if (oldWeatherData != null) {
      for (final newWeatherData in newWeatherDataList) {
        if (DateUtils.isSameDay(newWeatherData.time, oldWeatherData.time)) {
          return newWeatherData;
        }
      }
    }
    return null;
  }

  CityData? _getNextCityData(CityData selectedCityData, List<CityData> cityDataList) {
    if (cityDataList.isEmpty) {
      return null;
    }
    var index = cityDataList.indexOf(selectedCityData) + 1;
    if (index >= cityDataList.length) {
      index = 0;
    }
    return cityDataList[index];
  }
}
