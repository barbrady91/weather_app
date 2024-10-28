// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      time: DateTime.parse(json['time'] as String),
      values: WeatherValues.fromJson(json['values'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'values': instance.values,
    };

WeatherValues _$WeatherValuesFromJson(Map<String, dynamic> json) =>
    WeatherValues(
      temperatureAvg: (json['temperatureAvg'] as num).toDouble(),
      temperatureMax: (json['temperatureMax'] as num).toDouble(),
      temperatureMin: (json['temperatureMin'] as num).toDouble(),
      humidityAvg: (json['humidityAvg'] as num).toDouble(),
      pressureSurfaceLevelAvg:
          (json['pressureSurfaceLevelAvg'] as num).toDouble(),
      windSpeedAvg: (json['windSpeedAvg'] as num).toDouble(),
    );

Map<String, dynamic> _$WeatherValuesToJson(WeatherValues instance) =>
    <String, dynamic>{
      'temperatureAvg': instance.temperatureAvg,
      'temperatureMax': instance.temperatureMax,
      'temperatureMin': instance.temperatureMin,
      'humidityAvg': instance.humidityAvg,
      'pressureSurfaceLevelAvg': instance.pressureSurfaceLevelAvg,
      'windSpeedAvg': instance.windSpeedAvg,
    };
