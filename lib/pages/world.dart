import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/bloc/bloc.dart';
import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/services/world_aggregated_service.dart';
import 'package:covid19tracker/widgets/daily_chart.dart';
import 'package:covid19tracker/widgets/main_data_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class World extends StatefulWidget {
  @override
  _WorldState createState() => _WorldState();
}

class _WorldState extends FutureBuilderState<World> {
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
    return BlocProvider(
        create: (context) => WorldDataBloc(service: WorldAggregatedService())..add(WorldDataFetch()),
        child: BlocBuilder<WorldDataBloc, WorldDataState>(
          builder: (context, state) {
            if (state is WorldDataLoaded) {
              if (state.worldData == null || state.worldData.isEmpty) {
                return super.buildNoData();
              }

              return _buildDataView(state.worldData);
            }

            if (state is WorldDataFailure) {
              return super.buildError(
                  state.exception, () => BlocProvider.of<WorldDataBloc>(context).add(WorldDataFetch()));
            }

            if (state is WorldDataInitial) {
              return super.buildLoader();
            }

            return super.buildNoData();
          },
        ));
  }
}
