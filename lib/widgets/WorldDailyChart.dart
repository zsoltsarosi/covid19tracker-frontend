import 'package:covid19tracker/helper/ExtensionMethods.dart';
import 'package:covid19tracker/model/WorldAggregated.dart';

/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class WorldDailyChart extends StatelessWidget {
  final List<WorldAggregated> data;
  final ColorScheme colorScheme;

  List<charts.Series> _seriesList;

  WorldDailyChart(this.data, this.colorScheme) {
    _seriesList = _createSeries();
  }

  @override
  Widget build(BuildContext context) {

    // Create the ticks to be used the domain axis.
    final staticTicks = <charts.TickSpec<String>>[
      new charts.TickSpec(
          // Value must match the domain value.
          '2014',
          // Optional label for this tick, defaults to domain value if not set.
          label: 'Year 2014',
          // The styling for this tick.
          style: new charts.TextStyleSpec(
              color: new charts.Color(r: 0x4C, g: 0xAF, b: 0x50))),
      // If no text style is specified - the style from renderSpec will be used
      // if one is specified.
      new charts.TickSpec('02.01'),
      new charts.TickSpec('03.01'),
      new charts.TickSpec('04.01'),
    ];
    
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      _seriesList,
      animate: false,
      barGroupingType: charts.BarGroupingType.stacked,
      behaviors: [new charts.SeriesLegend()],
      domainAxis: new charts.OrdinalAxisSpec(
        // Make sure that we draw the domain axis line.
        showAxisLine: true,
        // But don't draw anything else.
        //renderSpec: new charts.NoneRenderSpec(),
        tickProviderSpec: new charts.StaticOrdinalTickProviderSpec(staticTicks),
      ),
    );
  }

  /// Create series list with multiple seriess
  List<charts.Series<WorldMetric, String>> _createSeries() {
    final uncertain = [
      for (var piece in data) WorldMetric(piece.date, piece.confirmed - piece.recovered - piece.deaths)
    ];

    final recovered = [for (var piece in data) WorldMetric(piece.date, piece.recovered)];

    final died = [for (var piece in data) WorldMetric(piece.date, piece.deaths)];

    return [
      new charts.Series<WorldMetric, String>(
          id: 'Confirmed',
          domainFn: (WorldMetric data, _) => new DateFormat("MM.dd").format(data.day),
          measureFn: (WorldMetric data, _) => data.cases,
          data: uncertain,
          colorFn: (WorldMetric data, _) => this.colorScheme.confirmed.toChartColor()),
      new charts.Series<WorldMetric, String>(
        id: 'Recovered',
        domainFn: (WorldMetric data, _) => new DateFormat("MM.dd").format(data.day),
        measureFn: (WorldMetric data, _) => data.cases,
        data: recovered,
        colorFn: (WorldMetric data, _) => this.colorScheme.recovered.toChartColor(),
      ),
      new charts.Series<WorldMetric, String>(
        id: 'Deaths',
        domainFn: (WorldMetric data, _) => new DateFormat("MM.dd").format(data.day),
        measureFn: (WorldMetric data, _) => data.cases,
        data: died,
        colorFn: (WorldMetric data, _) => this.colorScheme.died.toChartColor(),
      ),
    ];
  }
}

// stores number of confirmed or recovered or died for one day
class WorldMetric {
  final DateTime day;
  final int cases;

  WorldMetric(this.day, this.cases);
}
