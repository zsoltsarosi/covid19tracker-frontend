import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid19tracker/helper/extension_methods.dart';
import 'package:covid19tracker/model/world_aggregated.dart';
import 'package:covid19tracker/widgets/figure_container.dart';
/// Bar chart example
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorldDailyChart extends StatefulWidget {
  final List<WorldAggregated> data;
  final ColorScheme colorScheme;

  WorldDailyChart({Key key, @required this.data, @required this.colorScheme}) : super(key: key);

  @override
  _WorldDailyChartState createState() => _WorldDailyChartState();
}

class _WorldDailyChartState extends State<WorldDailyChart> {
  List<WorldAggregated> _data;
  ColorScheme _colorScheme;
  List<charts.Series> _seriesList;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _colorScheme = widget.colorScheme;
    _seriesList = _createSeries();
  }

  @override
  Widget build(BuildContext context) {
    return FigureContainer(
        height: 300,
        child: charts.LineChart(
          _seriesList,
          animate: false,
          behaviors: [
            charts.SeriesLegend(
              entryTextStyle: charts.TextStyleSpec(fontSize: 10),
            )
          ],
          domainAxis: charts.NumericAxisSpec(
            // Make sure that we draw the domain axis line.
            showAxisLine: true,
            tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num value) {
              var date = DateTime(2020, 1, 1).add(Duration(days: value.round()));
              return DateFormat.MMMd().format(date);
            }),
          ),
          defaultRenderer: charts.LineRendererConfig(includeLine: true, includeArea: true, stacked: true),
        ));
  }

  int daysSince2020Jan1(DateTime date) {
    return date.difference(DateTime(2020, 1, 1)).inDays;
  }

  /// Create series list with multiple seriess
  List<charts.Series<WorldMetric, int>> _createSeries() {
    final uncertain = [
      for (var piece in _data) WorldMetric(piece.date, piece.confirmed - piece.recovered - piece.deaths)
    ];

    final recovered = [for (var piece in _data) WorldMetric(piece.date, piece.recovered)];

    final died = [for (var piece in _data) WorldMetric(piece.date, piece.deaths)];

    return [
      charts.Series<WorldMetric, int>(
        id: 'Deaths',
        domainFn: (WorldMetric data, _) => daysSince2020Jan1(data.date),
        measureFn: (WorldMetric data, _) => data.cases,
        data: died,
        colorFn: (WorldMetric data, _) => _colorScheme.died.toChartColor(),
      ),
      charts.Series<WorldMetric, int>(
        id: 'Recovered',
        domainFn: (WorldMetric data, _) => daysSince2020Jan1(data.date),
        measureFn: (WorldMetric data, _) => data.cases,
        data: recovered,
        colorFn: (WorldMetric data, _) => _colorScheme.recovered.toChartColor(),
      ),
      charts.Series<WorldMetric, int>(
          id: 'Confirmed',
          domainFn: (WorldMetric data, _) => daysSince2020Jan1(data.date),
          measureFn: (WorldMetric data, _) => data.cases,
          data: uncertain,
          colorFn: (WorldMetric data, _) => _colorScheme.confirmed.toChartColor()),
    ];
  }
}

// stores number of confirmed or recovered or died for one day
class WorldMetric {
  final DateTime date;
  final int cases;

  WorldMetric(this.date, this.cases);
}
