import 'package:covid19tracker/constants.dart';
import 'package:flutter/material.dart';

class FigureContainer extends StatelessWidget {
  final Widget child;

  FigureContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: new BoxDecoration(
          color: kFigureBackground,
          borderRadius: new BorderRadius.circular(5.0),
          boxShadow: [BoxShadow(offset: Offset(0, 4), blurRadius: 5, color: kShadowColor)]),
      child: child,
    );
  }
}
