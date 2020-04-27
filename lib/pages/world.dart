import 'package:covid19tracker/model/world_aggregated.dart';
import 'package:covid19tracker/services/world_aggregated.dart';
import 'package:covid19tracker/widgets/world_aggregated_current.dart';
import 'package:covid19tracker/widgets/world_daily_chart.dart';
import 'package:flutter/material.dart';

class World extends StatefulWidget {
  @override
  _WorldState createState() => _WorldState();
}

class _WorldState extends State<World> {
  final WorldAggregatedService service = WorldAggregatedService();
  Future<List<WorldAggregated>> getDataFuture;

  void getData() {
    this.getDataFuture = this.service.getData();
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Widget _buildLoader() {
    return Center(
        child: SizedBox(
      child: CircularProgressIndicator(),
      width: 20,
      height: 20,
    ));
  }

  Widget _buildError(Object error) {
    return Column(
      children: <Widget>[
        Text('Error loading data'),
        IconButton(
            icon: Icon(Icons.refresh, color: Colors.black, size: 20),
            onPressed: () {
              this.getData();
              setState(() {});
            }),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  Widget _buildDataView(List<WorldAggregated> data) {
    return Container(
      // color: Colors.blueGrey[200],
      child: Column(
        children: <Widget>[
          Expanded(child: WorldAggregatedCurrent(data: data.last), flex: 1),
          Expanded(child: WorldDailyChart(data: data, colorScheme: Theme.of(context).colorScheme), flex: 3),
        ],
      ),
    );
  }

  Widget _buildNoData() {
    return Container(width: 0.0, height: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WorldAggregated>>(
      future: this.getDataFuture,
      builder: (BuildContext context, AsyncSnapshot<List<WorldAggregated>> snapshot) {
        print('${snapshot.hasData} ${snapshot.hasError}');

        if (snapshot.connectionState != ConnectionState.done) {
          return _buildLoader();
        }
        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        }
        if (snapshot.hasData) {
          return _buildDataView(snapshot.data);
        }

        return _buildNoData();
      },
    );
  }
}
