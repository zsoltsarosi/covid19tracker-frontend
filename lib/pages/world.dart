import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/model/world_aggregated.dart';
import 'package:covid19tracker/services/world_aggregated_service.dart';
import 'package:covid19tracker/widgets/daily_chart.dart';
import 'package:covid19tracker/widgets/main_data_view.dart';
import 'package:flutter/material.dart';

class World extends StatefulWidget {
  @override
  _WorldState createState() => _WorldState();
}

class _WorldState extends FutureBuilderState<World> {
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

  Widget _buildDataView(List<WorldAggregated> data) {
    return Container(
      // color: Colors.blueGrey[200],
      child: Column(
        children: <Widget>[
          Expanded(child: MainDataView(data: data.last, increaseRate: data.last.increaseRate), flex: 1),
          Expanded(child: DailyChart(data: data, colorScheme: Theme.of(context).colorScheme), flex: 3),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WorldAggregated>>(
      future: this.getDataFuture,
      builder: (BuildContext context, AsyncSnapshot<List<WorldAggregated>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return super.buildLoader();
        }
        if (snapshot.hasError) {
          return super.buildError(snapshot.error);
        }
        if (snapshot.hasData) {
          return _buildDataView(snapshot.data);
        }

        return super.buildNoData();
      },
    );
  }
}
