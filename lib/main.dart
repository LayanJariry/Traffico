import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
 
  Completer<GoogleMapController> mapController = Completer();
late LatLng initialPosition =
      const LatLng(31.900883058179527, 35.9346984671693);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.756013, 36.338258),
    zoom: 12.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    initializeMap();
    super.initState();
  }

  void initializeMap() async {
 
     await getCurrentLocation();

   }

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          mapController.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getCurrentLocation,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
 
   void goToPosition(Position position) async {
    final GoogleMapController Controller = await mapController.future;
    print(position);
    Controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15.151926040649414,
      ),
    ));
  }
  Future<void> getCurrentLocation() async {
   

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
    } else if (permission == LocationPermission.deniedForever) {
    } else {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        initialPosition = LatLng(position.latitude, position.longitude);
        print(position);

        goToPosition(position);
        // ignore: empty_catches
      } catch (e) {}
    }
  }
}
 