import 'package:covid19tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/';

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
    await Future.delayed(new Duration(seconds: 1));
    // should load the initial data here
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: kMainBgGradient1,
      body: Center(
        child: Shimmer.fromColors(
            child: Text("Loading data ...", style: textTheme.headline5), baseColor: Colors.white30, highlightColor: Colors.white),
      ),
    );
  }
}
