import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'models/localizacao.model.dart';
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Position> _positions = [];

  @override
  void initState() {
    super.initState();
    _startStreamLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Speed Tracker",
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tracker'),
        ),
        body: ListView.builder(
          itemCount: _positions.length,
          itemBuilder: (context, index) {
            final item = _positions[index];

            return ListTile(
              title: Text(
                  "Localização: ${item.latitude.toStringAsFixed(4)} ${item.longitude.toStringAsFixed(4)}"),
              subtitle: Text(
                  "Velocidade: ${(item.speed * 3.6).toStringAsFixed(2)} km/h às ${DateFormat('HH:mm:ss').format(DateTime.now())}"),
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
            _positions.add(position);
          }
        });
      });
    }
  }

  Future<Localizacao> createLocation(
      int codLocalizacao,
      double latitude,
      double longitude,
      String codUsuario,
      DateTime dataHoraCad,
      double velocidade) async {
    const String url = 'https://sat.perto.com.br/prjSATWebAPI/api/Localizacao';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'codLocalizacao': codLocalizacao.toString(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'codUsuario': codUsuario,
        'dataHoraCad': dataHoraCad.toString(),
        'velocidade': velocidade.toString(),
      }),
    );

    if (response.statusCode == 201) {
      return Localizacao.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create location.');
    }
  }
}
