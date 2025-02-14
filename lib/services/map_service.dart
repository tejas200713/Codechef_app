import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class MapService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  static Future<List<Location>> fetchLocations(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl?q=$query&format=json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Location(
        latitude: double.parse(item['lat']),
        longitude: double.parse(item['lon']),
        name: item['display_name']
      )).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }
}