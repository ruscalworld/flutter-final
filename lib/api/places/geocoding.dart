import 'dart:convert';

import 'package:pr_final/api/places/place.dart';
import 'package:http/http.dart' as http;

class PlaceImpl extends Place {
  @override
  final String displayName;

  @override
  final double latitude;

  @override
  final double longitude;

  PlaceImpl({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });
}

class GeocodingAPI {
  final String token;

  GeocodingAPI({required this.token});

  Future<List<PlaceImpl>> findPlaces(String query) async {
    Uri uri = Uri.parse('https://geocode.maps.co/search');

    uri = uri.replace(queryParameters: {
      'q': query,
      'api_key': token,
    });

    final response = await http.get(uri);

    return switch (response.statusCode) {
      200 => parsePlaceList(jsonDecode(response.body)),
      _ => throw Exception('Error response status ${response.statusCode}: ${response.body}'),
    };
  }

  List<PlaceImpl> parsePlaceList(List<dynamic> json) {
    json.retainWhere((item) => item['type'] != 'administrative');

    return json.map((item) => PlaceImpl(
        displayName: item['display_name'],
        latitude: double.parse(item['lat']),
        longitude: double.parse(item['lon']),
    )).toList();
  }
}