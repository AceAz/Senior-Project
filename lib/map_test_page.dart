import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTestPage extends StatelessWidget {
  const MapTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Test')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.4220, -122.0841),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('test'),
            position: LatLng(37.4220, -122.0841),
          ),
        },
        myLocationEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}
