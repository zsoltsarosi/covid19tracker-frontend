import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    onStart();
  }

  void onStart() async {
    // TODO temp to simulate splash screen
    await Future.delayed(new Duration(seconds: 1));
    Navigator.pushReplacementNamed(context, '/home');
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
