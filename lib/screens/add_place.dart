import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:pr_final/api/places/geocoding.dart';
import 'package:pr_final/api/places/place.dart';
import 'package:pr_final/api/state/provider.dart';
import 'package:pr_final/screens/places.dart';
import 'package:pr_final/screens/weather.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final GeocodingAPI geocoding = GetIt.I<GeocodingAPI>();
  final TextEditingController fieldController = TextEditingController();

  List<Place> matchedPlaces = [];
  String? error;
  
  void updateMatchedPlaces() {

    geocoding.findPlaces(fieldController.value.text)
        .then((places) {
          setState(() => matchedPlaces = places);
        })
        .onError((error, stackTrace) {
          setState(() => this.error = error.toString());
        });
  }
  
  @override
  Widget build(BuildContext context) {
    final placeStore = StateProvider.of(context).placeStore;
    if (error != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error!)));
        setState(() => error = null);
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить место'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (_) => updateMatchedPlaces,
                      onEditingComplete: updateMatchedPlaces,
                      controller: fieldController,
                    ),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: updateMatchedPlaces,
                    child: const Text('Найти'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: matchedPlaces.map((place) => PlaceRow(
                  key: ValueKey('(${place.latitude} ${place.longitude})'),
                  place: place,
                  onPicked: () {
                    placeStore.saveAndPickPlace(place);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WeatherScreen()), (route) => false);
                  },
                )).toList(),
              ),
            ),
          ],
        ),
      )
    );
  }
}
