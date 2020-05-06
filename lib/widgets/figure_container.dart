import 'package:flutter/material.dart';

class FigureContainer extends StatelessWidget {
  final Widget child;
  final double height;

  FigureContainer({Key key, this.height, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: new BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: new BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 5,
            color: Color(0xFF222222).withOpacity(.16))
        ]
      ),
      height: height,
      child: child,

    );
  }
}
