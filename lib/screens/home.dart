import 'package:covid19tracker/helper/WorldAggregatedFeed.dart';
import 'package:covid19tracker/model/WorldAggregated.dart';
import 'package:covid19tracker/screens/drawer.dart';
import 'package:covid19tracker/widgets/FigureContainer.dart';
import 'package:covid19tracker/widgets/WorldAggregatedCurrent.dart';
import 'package:covid19tracker/widgets/WorldDailyChart.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final WorldAggregatedFeed feed;
  
  MainScreen({Key key, @required this.feed}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<WorldAggregated> _data;
  WorldAggregated _lastDay;

  @override
  void initState() {
    super.initState();

    widget.feed.getWorldData().then((List<WorldAggregated> data) {
      setState(() {
        _data = data;
        _lastDay = data.last;
      });
    });
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0x00000000),
      appBar: AppBar(
        // backgroundColor: const Color(0x00000000),
        // elevation: 0.0,
        title: Text("COVID-19 Tracker"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.person,
                  size: 26.0,
                ),
              )),
        ],
      ),
      drawer: DrawerWidget(),
      body: Container(
        color: Colors.blueGrey[200],
        child: ListView(
          children: <Widget>[
            WorldAggregatedCurrent(data: _lastDay),
            Divider(),
            FigureContainer(
              height: 300,
              child: WorldDailyChart(_data, Theme.of(context).colorScheme)
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            title: Text('World'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            title: Text('Countries'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text('News'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
