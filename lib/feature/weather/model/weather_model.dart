import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/feature/weather/data/weather_data.dart';

const _apiKey = 'your_api_key'; //todo: replace with your own api key!

/// The Model for [WeatherData] which handles all weather related operations.
class WeatherModel {
  Future<List<WeatherData>> fetchData({required double latitude, required double longitude}) async {
    final url = Uri.parse('https://api.tomorrow.io/v4/weather/forecast?location=$latitude,$longitude&timesteps=1d&apikey=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('[WeatherModel.fetchData]: could not load weather (statusCode: ${response.statusCode})');
    }
    final json = jsonDecode(response.body);
    final values = json['timelines']['daily'];
    final weatherDataList = <WeatherData>[];
    for (final value in values) {
      final weatherData = WeatherData.fromJson(value);
      weatherDataList.add(weatherData);
    }
    return weatherDataList;
  }
}
