import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentLocation;
  bool _isLoading = false;
  String _errorMessage = '';

  Position? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCurrentLocation() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = "Location services are disabled.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = "Location permission denied.";
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = "Location permission is permanently denied. Enable it from settings.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _errorMessage = "Error getting location: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location loc = locations.first;
        _currentLocation = Position(
          latitude: loc.latitude,
          longitude: loc.longitude,
          timestamp: DateTime.now(),
          accuracy: loc.accuracy ?? 10, // Provide a fallback value
          altitude: loc.altitude ?? 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          // New required fields in newer versions of Geolocator:
          altitudeAccuracy: 0, // Provide a fallback if you don't have real data
          headingAccuracy: 0,  // Provide a fallback if you don't have real data
          isMocked: false,     // Set this to true if you know the location is mocked
          // If your Geolocator version also requires 'floor', include it:
          // floor: 0,
        );
      } else {
        _errorMessage = "No results found for '$query'.";
      }
    } catch (e) {
      _errorMessage = "Error searching location: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}
