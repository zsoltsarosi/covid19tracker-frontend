
import 'package:covid19tracker/model/WorldAggregated.dart';
import 'package:covid19tracker/widgets/WorldAggregatedCurrent.dart';
import 'package:covid19tracker/widgets/WorldDailyChart.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final List<WorldAggregated> data;
  
  Home(this.data);
  
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.blueGrey[200],
        child: Column(
            children: <Widget>[
              Expanded(child: WorldAggregatedCurrent(data: data.last), flex: 1),
              Expanded(child: WorldDailyChart(data, Theme.of(context).colorScheme), flex: 3),
            ],
          ),
      );
  }
}