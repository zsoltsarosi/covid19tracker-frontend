
import 'package:covid19tracker/screens/loading_screen.dart';
import 'package:covid19tracker/screens/main_screen.dart';
import 'package:covid19tracker/screens/news_reader.dart';
import 'package:flutter/material.dart';

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
      routes: {
        LoadingScreen.routeName: (context) => LoadingScreen(),
        MainScreen.routeName: (context) => MainScreen(),
        NewsReader.routeName: (context) => NewsReader(),
      },
      initialRoute: LoadingScreen.routeName,
    );
  }
}
