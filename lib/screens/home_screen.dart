import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../widgets/map_widget.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              locationProvider.searchLocation(_searchController.text);
            },
          ),
        ],
      ),
      body: locationProvider.isLoading
          ? LoadingIndicator()
          : MapWidget(locationProvider: locationProvider),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search Location',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}