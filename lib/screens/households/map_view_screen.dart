import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/survey_provider.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household Map View (OSM)'),
      ),
      body: Consumer<SurveyProvider>(
        builder: (context, provider, child) {
          final households = provider.households;
          
          // Filter households with valid coordinates
          final validHouseholds = households.where((h) => h.latitude != 0 && h.longitude != 0).toList();

          // Markers for each household
          final markers = validHouseholds.map((h) {
            return Marker(
              point: LatLng(h.latitude, h.longitude),
              width: 80,
              height: 80,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('House No: ${h.houseNumber}\nHead: ${h.headName}')),
                  );
                },
                child: const Icon(
                  Icons.location_on,
                  color: Colors.indigo,
                  size: 40,
                ),
              ),
            );
          }).toList();

          // Initial center point
          LatLng initialCenter = const LatLng(0, 0);
          double initialZoom = 2;

          if (validHouseholds.isNotEmpty) {
            initialCenter = LatLng(validHouseholds.first.latitude, validHouseholds.first.longitude);
            initialZoom = 13;
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: initialZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.surveysync.app',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
