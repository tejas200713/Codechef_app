import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/location_provider.dart';

class MapWidget extends StatelessWidget {
  final LocationProvider locationProvider;

  MapWidget({required this.locationProvider});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(
          locationProvider.currentLocation?.latitude ?? 0,
          locationProvider.currentLocation?.longitude ?? 0,
        ),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
            if (locationProvider.currentLocation != null)
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(
                  locationProvider.currentLocation!.latitude,
                  locationProvider.currentLocation!.longitude,
                ),
                builder: (ctx) => Icon(Icons.location_pin, color: Colors.red, size: 40),
              ),
          ],
        ),
      ],
    );
  }
}
