import 'package:flutter/material.dart';
import 'speed_tracker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      home: const SpeedTracker(title: 'Speed Tracker'),
    );
  }
}
