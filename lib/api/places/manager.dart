import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'place.dart';

class PlaceImpl implements Place {
  @override
  final String displayName;

  @override
  final double latitude;

  @override
  final double longitude;

  PlaceImpl({required this.displayName, required this.latitude, required this.longitude});

  factory PlaceImpl.fromJson(Map<String, dynamic> json) {
    return PlaceImpl(
        displayName: json['displayName'],
        latitude: json['latitude'],
        longitude: json['longitude'],
    );
  }
}

class PlaceManager {
  final List<Place> _savedPlaces = [];

  List<Place> getSavedPlaces() {
    return _savedPlaces;
  }

  void addPlace(Place place) {
    _savedPlaces.add(place);
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('places', _savedPlaces.map((place) {
      return jsonEncode({
        'displayName': place.displayName,
        'latitude': place.latitude,
        'longitude': place.longitude,
      });
    }).toList());
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final places = prefs.getStringList('places');
    if (places == null) return;

    _savedPlaces.addAll(places.map((rawPlace) {
      final place = jsonDecode(rawPlace);
      return PlaceImpl.fromJson(place);
    }));
  }
}
