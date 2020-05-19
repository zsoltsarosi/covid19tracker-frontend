import 'package:covid19tracker/constants.dart';
import 'package:covid19tracker/pages/information.dart';
import 'package:covid19tracker/screens/main_screen.dart';
import 'package:flutter/material.dart';

class AnimatedDrawer extends StatefulWidget {
  final Widget child;

  const AnimatedDrawer({Key key, @required this.child}) : super(key: key);

  static AnimatedDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<AnimatedDrawerState>();

  @override
  AnimatedDrawerState createState() => new AnimatedDrawerState();
}

class AnimatedDrawerState extends State<AnimatedDrawer> with SingleTickerProviderStateMixin {
  static const Duration toggleDuration = Duration(milliseconds: 250);
  static const double maxSlide = 225;
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;
  AnimationController _animationController;
  bool _canBeDragged = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AnimatedDrawerState.toggleDuration,
    );
  }

  void close() => _animationController.reverse();

  void open() => _animationController.forward();

  void toggleDrawer() => _animationController.isCompleted ? close() : open();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_animationController.isCompleted) {
          close();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
          animation: _animationController,
          child: widget.child,
          builder: (context, child) {
            double animValue = _animationController.value;
            final slideAmount = maxSlide * animValue;
            final contentScale = 1.0 - (0.3 * animValue);
            return Stack(
              children: <Widget>[
                MyDrawer(),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slideAmount)
                    ..scale(contentScale, contentScale),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _animationController.isCompleted ? close : null,
                    child: child,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        _animationController.isDismissed && details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight =
        _animationController.isCompleted && details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: kMainBgGradient1,
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ListTile(
                  title: Center(
                      child: Column(
                    children: <Widget>[
                      Text('Created by Zsolt Sarosi with \u2665'),
                      Text('In the lockdown of Budapest, 2020'),
                      SizedBox(height: 40),
                    ],
                  )),
                ),
                ListTile(
                  leading: Icon(Icons.public),
                  title: Text('World'),
                  onTap: () {
                    AnimatedDrawer.of(context).close();
                    MainScreen.of(context).selectPage(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Countries'),
                  onTap: () {
                    AnimatedDrawer.of(context).close();
                    MainScreen.of(context).selectPage(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.rss_feed),
                  title: Text('News'),
                  onTap: () {
                    AnimatedDrawer.of(context).close();
                    MainScreen.of(context).selectPage(2);
                  },
                ),
                Expanded(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Information'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationPage(),
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Column(
                    children: <Widget>[
                      Text('Conceptional and UI Design: \u2726 Xuezhou Fan \u2726'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
