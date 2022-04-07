import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'db/sql_helper.dart';
import 'dart:async';

class SpeedTracker extends StatefulWidget {
  const SpeedTracker({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SpeedTracker> createState() => _SpeedTrackerState();
}

class _SpeedTrackerState extends State<SpeedTracker> {
  List<Map<String, dynamic>> _locations = [];

  @override
  void initState() {
    super.initState();
    _refreshLocations();
    _startStreamLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Speed Tracker'),
        ),
        body: ListView.builder(
          itemCount: _locations.length,
          itemBuilder: (context, index) {
            final item = _locations[index];
            String speed =
                double.parse(item['velocidade'].toString()).toStringAsFixed(1);
            String lat =
                double.parse(item['latitude'].toString()).toStringAsFixed(4);
            String lng =
                double.parse(item['longitude'].toString()).toStringAsFixed(4);

            return ListTile(
              title: Text("Localização: $lat, $lng"),
              subtitle:
                  Text("Velocidade: $speed km/h às ${item['dataHoraCad']}"),
            );
          },
        ),
      ),
    );
  }

  _startStreamLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      // ignore: prefer_const_constructors
      LocationSettings settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Geolocator.getPositionStream(locationSettings: settings)
          .listen((Position? position) {
        setState(() {
          if (position != null) {
            _addLocation(position.latitude, position.longitude, 'SAT',
                position.speed * 3.6);
            _refreshLocations();
          }
        });
      });
    }
  }

  void _refreshLocations() async {
    final data = await SQLHelper.getAll();
    setState(() {
      _locations = data;
    });
  }

  Future<void> _addLocation(double latitude, double longitude,
      String codUsuario, double velocidade) async {
    await SQLHelper.create(latitude, longitude, codUsuario, velocidade);
    _refreshLocations();
  }
}
