import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pr_final/api/state/provider.dart';
import 'package:pr_final/screens/places.dart';
import 'package:pr_final/screens/welcome.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StateProvider.of(context).placeStore;
    if (!store.placesLoaded) store.loadPlaces();

    if (store.placesLoaded && store.placeManager.getSavedPlaces().isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
      });
    } else if (store.placesLoaded) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PlacesScreen()));
      });
    }

    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white)
      ),
    );
  }
}
