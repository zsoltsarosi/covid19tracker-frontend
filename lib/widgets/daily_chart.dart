import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid19tracker/helper/extension_methods.dart';
import 'package:covid19tracker/model/single_day_data.dart';
import 'package:covid19tracker/widgets/figure_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyChart extends StatefulWidget {
  final List<String> labels;
  final List<SingleDayData> data;
  final ColorScheme colorScheme;

  DailyChart({Key key, @required this.labels, @required this.data, @required this.colorScheme})
      : assert(data != null),
        super(key: key);

  @override
  _DailyChartState createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {
  List<SingleDayData> _data;
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
    var textTheme = Theme.of(context).textTheme;
    var legendStyle = textTheme.caption;
    Locale myLocale = Localizations.localeOf(context);
    var numFormatter = NumberFormat("#,###", myLocale.languageCode);
    var dateFormater = DateFormat.MMMd(myLocale.languageCode);
    return FigureContainer(
        child: charts.LineChart(
      _seriesList,
      animate: false,
      behaviors: [charts.SeriesLegend(
        // position: charts.BehaviorPosition.inside,
        // outsideJustification: charts.OutsideJustification.start,
        cellPadding: new EdgeInsets.only(right: 8.0, bottom: 4.0),
        entryTextStyle: charts.TextStyleSpec(
              color: legendStyle.color.toChartColor(),
              fontFamily: legendStyle.fontFamily,
              fontSize: legendStyle.fontSize.toInt()),
      )],
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num value) {
          return numFormatter.format(value);
        }),
      ),
      domainAxis: charts.NumericAxisSpec(
        showAxisLine: true,
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num value) {
          var date = DateTime(2020, 1, 1).add(Duration(days: value.round()));
          return dateFormater.format(date);
        }),
      ),
      defaultRenderer: charts.LineRendererConfig(includeLine: true, includeArea: true, stacked: true),
    ));
  }

  int daysSince2020Jan1(DateTime date) {
    return date.difference(DateTime(2020, 1, 1)).inDays;
  }

  /// Create series list with multiple seriess
  List<charts.Series<SingleMetric, int>> _createSeries() {
    final uncertain = [
      for (var piece in _data) SingleMetric(piece.date, piece.confirmed - piece.recovered - piece.deaths)
    ];

    final recovered = [for (var piece in _data) SingleMetric(piece.date, piece.recovered)];

    final died = [for (var piece in _data) SingleMetric(piece.date, piece.deaths)];

    return [
      charts.Series<SingleMetric, int>(
        id: widget.labels[0],
        domainFn: (SingleMetric data, _) => daysSince2020Jan1(data.date),
        measureFn: (SingleMetric data, _) => data.cases,
        data: died,
        colorFn: (SingleMetric data, _) => _colorScheme.died.toChartColor(),
      ),
      charts.Series<SingleMetric, int>(
        id: widget.labels[1],
        domainFn: (SingleMetric data, _) => daysSince2020Jan1(data.date),
        measureFn: (SingleMetric data, _) => data.cases,
        data: recovered,
        colorFn: (SingleMetric data, _) => _colorScheme.recovered.toChartColor(),
      ),
      charts.Series<SingleMetric, int>(
          id: widget.labels[2],
          domainFn: (SingleMetric data, _) => daysSince2020Jan1(data.date),
          measureFn: (SingleMetric data, _) => data.cases,
          data: uncertain,
          colorFn: (SingleMetric data, _) => _colorScheme.confirmed.toChartColor()),
    ];
  }
}

// stores number of confirmed or recovered or died for one day
class SingleMetric {
  final DateTime date;
  final int cases;

  SingleMetric(this.date, this.cases);
}
