import 'package:flutter/material.dart';

enum WeatherType {
  sunny(
    color: Colors.yellow,
    backgroundColor: Colors.blue,
    icon: Icons.sunny,
    name: 'ясно',
    imageName: 'sunny.jpg',
  ),
  cloudy(
    color: Colors.blueGrey,
    backgroundColor: Colors.blueGrey,
    icon: Icons.cloud,
    name: 'облачно',
    imageName: 'cloudy.jpg',
  ),
  rainy(
    color: Colors.black12,
    backgroundColor: Colors.black12,
    icon: Icons.cloud,
    name: 'дождь',
    imageName: 'rainy.jpg',
  ),
  stormy(
    color: Colors.black12,
    backgroundColor: Colors.black12,
    icon: Icons.thunderstorm,
    name: 'сильный дождь',
    imageName: 'stormy.jpg',
  ),
  snowy(
    color: Colors.lightBlueAccent,
    backgroundColor: Colors.lightBlueAccent,
    icon: Icons.cloudy_snowing,
    name: 'снег',
    imageName: 'snowy.jpg',
  );

  final Color color;
  final Color backgroundColor;
  final IconData icon;
  final String name;
  final String imageName;

  const WeatherType({
    required this.color,
    required this.backgroundColor,
    required this.icon,
    required this.name,
    required this.imageName,
  });
}

abstract class Weather {
  WeatherType get type;
  double get temperature;
}

abstract class Forecast {
  List<BoundForecast> get forecast;
}

abstract class BoundForecast {
  DateTime get date;
  Weather get weather;
  DateTime get sunrise;
  DateTime get sunset;
}

abstract class WeatherForecast {
  Weather get currentWeather;
  Forecast get forecast;
}
