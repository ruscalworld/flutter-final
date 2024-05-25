import 'dart:convert';

import 'weather.dart';
import 'package:http/http.dart' as http;

class OpenMeteoAPI {
  Future<WeatherForecastImpl> getWeather(double latitude, double longitude) async {
    Uri uri = Uri.parse('https://api.open-meteo.com/v1/forecast');

    uri = uri.replace(queryParameters: {
      'latitude': latitude.toStringAsFixed(4),
      'longitude': longitude.toStringAsFixed(4),
      'current': 'temperature_2m,weather_code',
      'daily': 'temperature_2m_max,weather_code,sunrise,sunset',
      'timezone': 'Europe/Moscow',
    });

    final response = await http.get(uri);
    return switch(response.statusCode) {
      200 => WeatherForecastImpl.fromJson(jsonDecode(response.body) as Map<String, dynamic>),
      _ => throw Exception('Error response status ${response.statusCode}: ${response.body}')
    };
  }

  static WeatherType parseWeatherCode(int weatherCode) {
    return switch (weatherCode) {
      0 => WeatherType.sunny,
      1 || 2 || 3 || 45 || 48 => WeatherType.cloudy,
      51 || 53 || 55 || 61 || 63 || 65 => WeatherType.rainy,
      56 || 57 || 66 || 67 || 71 || 73 || 75 || 77 || 85 || 86 => WeatherType.snowy,
      80 || 81 || 82 || 95 || 96 || 99 => WeatherType.stormy,
      _ => WeatherType.sunny,
    };
  }
}

class WeatherForecastImpl implements WeatherForecast {
  @override
  final Weather currentWeather;

  @override
  final Forecast forecast;

  WeatherForecastImpl({required this.currentWeather, required this.forecast});

  factory WeatherForecastImpl.fromJson(Map<String, dynamic> json) {
    return WeatherForecastImpl(
      currentWeather: WeatherImpl.fromJson(json['current']),
      forecast: ForecastImpl.fromJson(json['daily']),
    );
  }
}

class WeatherImpl implements Weather {
  @override
  final WeatherType type;

  @override
  final double temperature;

  WeatherImpl({required this.type, required this.temperature});

  factory WeatherImpl.fromJson(Map<String, dynamic> json) {
    return WeatherImpl(
      type: OpenMeteoAPI.parseWeatherCode(json['weather_code']),
      temperature: json['temperature_2m'],
    );
  }
}

class ForecastImpl extends Forecast {
  @override
  final List<BoundForecast> forecast;

  ForecastImpl({required this.forecast});

  factory ForecastImpl.fromJson(Map<String, dynamic> json) {
    List<dynamic> dates = json['time'];
    List<dynamic> sunrise = json['sunrise'];
    List<dynamic> sunset = json['sunset'];
    List<dynamic> codes = json['weather_code'];
    List<dynamic> temperature = json['temperature_2m_max'];

    List<BoundForecast> forecast = [];
    for (int i = 0; i < dates.length; i++) {
      forecast.add(BoundForecastImpl(
        date: DateTime.parse(dates[i]),
        sunrise: DateTime.parse(sunrise[i]),
        sunset: DateTime.parse(sunset[i]),
        weather: WeatherImpl(
          type: OpenMeteoAPI.parseWeatherCode(codes[i]),
          temperature: temperature[i],
        ),
      ));
    }

    return ForecastImpl(forecast: forecast);
  }
}

class BoundForecastImpl extends BoundForecast {
  @override
  final DateTime date;

  @override
  final WeatherImpl weather;

  @override
  final DateTime sunrise;

  @override
  final DateTime sunset;

  BoundForecastImpl({
    required this.date,
    required this.weather,
    required this.sunrise,
    required this.sunset,
  });
}
