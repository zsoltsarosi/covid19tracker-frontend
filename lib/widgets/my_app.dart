import 'package:covid19tracker/localization/translations.dart';
import 'package:covid19tracker/screens/loading_screen.dart';
import 'package:covid19tracker/screens/main_screen.dart';
import 'package:covid19tracker/screens/news_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  final String env;
  MyApp({this.env});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => Translations.of(context).title,
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('hu', ''),
        const Locale('de', ''),
        const Locale('en', ''),
      ],
      debugShowCheckedModeBanner: env == "dev",
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        fontFamily: 'RobotoCondensed',
      ),
      routes: {
        LoadingScreen.routeName: (context) => LoadingScreen(),
        MainScreen.routeName: (context) => MainScreen(),
        NewsReader.routeName: (context) => NewsReader()
      },
      initialRoute: LoadingScreen.routeName,
    );
  }
}
