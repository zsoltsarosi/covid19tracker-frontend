import 'package:covid19tracker/helper/ExtensionMethods.dart';
import 'package:covid19tracker/model/WorldAggregated.dart';
import 'package:covid19tracker/widgets/FigureContainer.dart';

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
    final staticTicks = List<charts.TickSpec<String>>();
    for (var i = 20; i <= 22; i++)
      for (var j = 1; j <= 12; j++) {
        final yearFull = 2000 + i;
        final twoDigitJ = j.toString().padLeft(2, '0');
        var label = "$twoDigitJ.01";
        if (j == 1) label = "'$i.$twoDigitJ.01";
        staticTicks.add(charts.TickSpec('$yearFull.$twoDigitJ.01', label: label));
      }

    return FigureContainer(
        height: 300,
        child: charts.BarChart(
          _seriesList,
          animate: false,
          barGroupingType: charts.BarGroupingType.stacked,
          behaviors: [
            new charts.SeriesLegend(
              entryTextStyle: charts.TextStyleSpec(fontSize: 10),
            )
          ],
          domainAxis: new charts.OrdinalAxisSpec(
            // Make sure that we draw the domain axis line.
            showAxisLine: true,
            // But don't draw anything else.
            //renderSpec: new charts.NoneRenderSpec(),
            tickProviderSpec: new charts.StaticOrdinalTickProviderSpec(staticTicks),
          ),
        ));
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
          domainFn: (WorldMetric data, _) => new DateFormat("yyyy.MM.dd").format(data.day),
          measureFn: (WorldMetric data, _) => data.cases,
          data: uncertain,
          colorFn: (WorldMetric data, _) => this.colorScheme.confirmed.toChartColor()),
      new charts.Series<WorldMetric, String>(
        id: 'Recovered',
        domainFn: (WorldMetric data, _) => new DateFormat("yyyy.MM.dd").format(data.day),
        measureFn: (WorldMetric data, _) => data.cases,
        data: recovered,
        colorFn: (WorldMetric data, _) => this.colorScheme.recovered.toChartColor(),
      ),
      new charts.Series<WorldMetric, String>(
        id: 'Deaths',
        domainFn: (WorldMetric data, _) => new DateFormat("yyyy.MM.dd").format(data.day),
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
