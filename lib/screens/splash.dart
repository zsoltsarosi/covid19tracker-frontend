import 'package:covid19tracker/helper/WorldAggregatedFeed.dart';
import 'package:covid19tracker/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    onStart();
  }

  void onStart() async {
    await Future.delayed(new Duration(seconds: 1));
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => MainScreen(feed: WorldAggregatedFeed()))); //push to next screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Shimmer.fromColors(
            child: Text("Loading data ..."), baseColor: Colors.grey[500], highlightColor: Colors.white),
      ),
    );
  }
}
