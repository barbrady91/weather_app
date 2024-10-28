import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

/// Data object which can hold weather information.
@JsonSerializable()
class WeatherData {
  final DateTime time;
  final WeatherValues values;

  WeatherData({required this.time, required this.values});

  factory WeatherData.fromJson(Map<String, dynamic> json) => _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}

/// Data object which can hold weather values.
@JsonSerializable()
class WeatherValues {
  final double temperatureAvg;
  final double temperatureMax;
  final double temperatureMin;
  final double humidityAvg;
  final double pressureSurfaceLevelAvg;
  final double windSpeedAvg;

  WeatherValues({
    required this.temperatureAvg,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.humidityAvg,
    required this.pressureSurfaceLevelAvg,
    required this.windSpeedAvg,
  });

  factory WeatherValues.fromJson(Map<String, dynamic> json) => _$WeatherValuesFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherValuesToJson(this);
}
