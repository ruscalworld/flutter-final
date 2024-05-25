import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr_final/api/weather/weather.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DayInfoScreen extends StatelessWidget {
  final BoundForecast forecast;
  static final DateFormat dateFormat = DateFormat('dd MMMM');
  static final DateFormat timeFormat = DateFormat('HH:mm');

  const DayInfoScreen({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(dateFormat.format(forecast.date)),
        backgroundColor: forecast.weather.type.backgroundColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://cdn.petooh.site/weather/${forecast.weather.type.imageName}',
              fit: BoxFit.fitWidth,
              progressIndicatorBuilder: (_, __, progress) => CircularProgressIndicator(value: progress.progress),
            ),
            const SizedBox(height: 32),
            Property(title: 'температура воздуха', value: '${forecast.weather.temperature} ˚C'),
            const SizedBox(height: 32),
            Property(title: 'световой день', value: '${timeFormat.format(forecast.sunrise)} - ${timeFormat.format(forecast.sunset)}'),
          ],
        ),
      ),
    );
  }
}

class Property extends StatelessWidget {
  final String title;
  final String value;

  const Property({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
