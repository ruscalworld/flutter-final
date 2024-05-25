import 'package:flutter/material.dart';
import 'package:pr_final/api/places/place.dart';
import 'package:pr_final/api/state/provider.dart';
import 'package:pr_final/screens/add_place.dart';
import 'package:pr_final/screens/weather.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final placeStore = StateProvider.of(context).placeStore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Места'),
      ),
      body: ListView(
        children: placeStore.placeManager.getSavedPlaces().map((place) => PlaceRow(
          key: Key('(${place.latitude} ${place.longitude})'),
          place: place,
          onPicked: () {
            placeStore.pickPlace(place);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WeatherScreen()), (_) => false);
          },
        )).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPlaceScreen())),
      ),
    );
  }
}

class PlaceRow extends StatelessWidget {
  final Place place;
  final Function() onPicked;

  const PlaceRow({super.key, required this.place, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPicked,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(place.displayName),
          ],
        ),
      ),
    );
  }
}
