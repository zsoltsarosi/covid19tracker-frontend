import 'package:covid19tracker/helper/extension_methods.dart';
import 'package:covid19tracker/model/world_aggregated.dart';
import 'package:covid19tracker/widgets/figure_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorldAggregatedCurrent extends StatefulWidget {
  final WorldAggregated data;

  WorldAggregatedCurrent({Key key, @required this.data}) : super(key: key);

  @override
  _WorldAggregatedCurrentState createState() => _WorldAggregatedCurrentState();
}

class _WorldAggregatedCurrentState extends State<WorldAggregatedCurrent> {

  WorldAggregated _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return FigureContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: MainData(title: "Confirmed", value: _data.confirmed, color: Theme.of(context).colorScheme.confirmed),
              ),
              Expanded(
                child: MainData(title: "Recovered", value: _data.recovered, color: Theme.of(context).colorScheme.recovered),
              ),
              Expanded(
                child: MainData(title: "Died", value: _data.deaths, color: Theme.of(context).colorScheme.died),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text("Change: ${_data.increaseRate.toStringAsFixed(2)} %",
                      textAlign: TextAlign.center,
                      style: textTheme.subtitle.copyWith(fontSize: 10.0, fontWeight: FontWeight.normal)),
                ),
                Expanded(
                  child: Text(""),
                ),
                Expanded(
                  child: Text(
                      "Date: ${new DateFormat("yyyy-MM-dd").format(_data.date)}", // TODO: localized dateformat
                      textAlign: TextAlign.right,
                      style: textTheme.subtitle.copyWith(fontSize: 10.0, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MainData extends StatelessWidget {
  MainData({this.title, this.value, this.color});

  final NumberFormat formatter = NumberFormat();

  final String title;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    var valueStyle = textTheme.subtitle.copyWith(color: color);
    return new Container(
      padding: const EdgeInsets.all(5),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(this.title, style: textTheme.caption),
          SizedBox(height: 5),
          Text(formatter.format(this.value), style: valueStyle),
        ],
      ),
    );
  }
}
