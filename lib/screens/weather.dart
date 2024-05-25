import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pr_final/api/places/place.dart';
import 'package:pr_final/api/state/provider.dart';
import 'package:pr_final/api/weather/open_meteo.dart';
import 'package:pr_final/api/weather/weather.dart';
import 'package:pr_final/screens/day_info.dart';
import 'package:pr_final/screens/places.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = StateProvider.of(context);
    if (state.placeStore.currentPlace == null) {
      Future.delayed(Duration.zero).then((value) => {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PlacesScreen()))
      });
      return const Scaffold(body: CircularProgressIndicator());
    }

    return Observer(builder: (_) => WeatherScreenContent(currentPlace: state.placeStore.currentPlace!));
  }
}

class WeatherScreenContent extends StatefulWidget {
  final Place currentPlace;

  const WeatherScreenContent({super.key, required this.currentPlace});

  @override
  State<StatefulWidget> createState() => _WeatherScreenContentState();
}

class _WeatherScreenContentState extends State<WeatherScreenContent> {
  WeatherForecast? weather;
  String? error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      weather = null;
    });

    GetIt.I<OpenMeteoAPI>().getWeather(
        widget.currentPlace.latitude,
        widget.currentPlace.longitude
    ).then((weather) {
      setState(() => this.weather = weather);
    }).onError((error, stackTrace) {
      setState(() => this.error = error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error!)));
        setState(() => error = null);
      });
    }
    final body = weather == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SummaryContainer(weather: weather!.currentWeather),
              Expanded(child: ForecastContainer(forecast: weather!.forecast)),
            ],
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentPlace.displayName),
        backgroundColor: weather?.currentWeather.type.backgroundColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlacesScreen())),
            icon: const Icon(Icons.location_pin),
          ),
        ],
      ),
      body: body,
    );
  }
}

class SummaryContainer extends StatelessWidget {
  final Weather weather;

  const SummaryContainer({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: weather.type.backgroundColor,
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${weather.temperature.toStringAsFixed(0)} ˚C',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              weather.type.name,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForecastContainer extends StatelessWidget {
  final Forecast forecast;

  const ForecastContainer({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: forecast.forecast.map((forecast) => ForecastRow(
          key: ValueKey(forecast.date.toString()),
          forecast: forecast,
        )).toList(),
      ),
    );
  }
}

class ForecastRow extends StatelessWidget {
  final BoundForecast forecast;
  static final DateFormat primaryDateFormat = DateFormat('dd MMMM');
  static final DateFormat secondaryDateFormat = DateFormat('EEEE');

  const ForecastRow({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DayInfoScreen(forecast: forecast))),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryDateFormat.format(forecast.date),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    secondaryDateFormat.format(forecast.date),
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.black12),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 64,
              child: Icon(forecast.weather.type.icon, color: forecast.weather.type.color),
            ),
            SizedBox(
              width: 128,
              child: Text(
                '${forecast.weather.temperature.toStringAsFixed(0)} ˚C',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
