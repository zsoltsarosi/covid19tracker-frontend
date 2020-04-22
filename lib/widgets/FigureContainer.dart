import 'package:flutter/material.dart';

class FigureContainer extends StatelessWidget {
  final Widget child;
  final double height;

  FigureContainer({Key key, this.height, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      decoration: new BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: new BorderRadius.circular(5.0),
      ),
      height: height,
      child: child,
    );
  }
}
