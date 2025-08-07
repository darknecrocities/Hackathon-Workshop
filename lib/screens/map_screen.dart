import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _center = const LatLng(14.5995, 120.9842);
  late final GoogleMapController _controller;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchNearbySchools();
  }

  Future<void> _fetchNearbySchools() async {
    final key = dotenv.env['GOOGLE_MAPS_API_KEY'];
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
            '?location=${_center.latitude},${_center.longitude}'
            '&radius=100000'
            '&type=school'
            '&key=$key'
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body)['results'];
      setState(() {
        _markers.clear();
        for (var place in data) {
          final loc = place['geometry']['location'];
          _markers.add(Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(loc['lat'], loc['lng']),
            infoWindow: InfoWindow(title: place['name']),
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        onMapCreated: (c) => _controller = c,
        initialCameraPosition: CameraPosition(target: _center, zoom: 10),
        markers: _markers,
      ),
      if (_markers.isEmpty)
        const Center(child: CircularProgressIndicator()),
    ]);
  }
}
