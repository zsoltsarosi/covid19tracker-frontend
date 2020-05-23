import 'package:covid19tracker/constants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

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
    await Future.delayed(new Duration(milliseconds: 3500));
    // should load the initial data here
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainBgGradient1,
      body: FlareActor("assets/animation/Loading.flr", alignment:Alignment.center, fit:BoxFit.none, animation:"Loading"),
    );
  }
}
