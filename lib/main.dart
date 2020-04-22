
import 'package:flutter/material.dart';
import 'package:covid19tracker/screens/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19 Tracker',
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      home: SplashScreen(),
    );
  }
}
