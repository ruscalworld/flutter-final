import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pr_final/api/places/geocoding.dart';
import 'package:pr_final/api/state/place_store.dart';
import 'package:pr_final/api/state/provider.dart';
import 'package:pr_final/api/weather/open_meteo.dart';
import 'package:pr_final/screens/loading.dart';

const geocodingApiToken = String.fromEnvironment('GEOCODING_API_TOKEN');

void main() {
  GetIt.I.registerSingleton(OpenMeteoAPI());
  GetIt.I.registerSingleton(GeocodingAPI(token: geocodingApiToken));

  final placeStore = PlaceStore();

  runApp(StateProvider(
      placeStore: placeStore,
      child: const WeatherApp(),
  ));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoadingScreen(),
    );
  }
}
