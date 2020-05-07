import 'package:covid19tracker/helper/extension_methods.dart';
import 'package:covid19tracker/model/single_day_data.dart';
import 'package:covid19tracker/widgets/figure_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleDayView extends StatefulWidget {
  final SingleDayData data;
  final double increaseRate;

  SingleDayView({Key key, this.increaseRate, @required this.data}) : super(key: key);

  @override
  _SingleDayViewState createState() => _SingleDayViewState();
}

class _SingleDayViewState extends State<SingleDayView> {
  SingleDayData _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  Widget _buildIncreaseRate(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    if (widget.increaseRate == null) {
      return Container(width: 0.0, height: 0.0);
    }

    return Text("Change: ${widget.increaseRate.toStringAsFixed(2)} %",
        style: textTheme.subtitle.copyWith(fontSize: 10.0, fontWeight: FontWeight.normal));
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return FigureContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MainData(
                      title: "Confirmed",
                      value: _data.confirmed,
                      color: Theme.of(context).colorScheme.confirmed),
                ),
                Expanded(
                  child: MainData(
                      title: "Recovered",
                      value: _data.recovered,
                      color: Theme.of(context).colorScheme.recovered),
                ),
                Expanded(
                  child:
                      MainData(title: "Died", value: _data.deaths, color: Theme.of(context).colorScheme.died),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildIncreaseRate(context),
                ),
                Text("Date: ${DateFormat.yMd().format(_data.date)}",
                    style: textTheme.subtitle.copyWith(fontSize: 10.0, fontWeight: FontWeight.normal)),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(this.title, style: textTheme.caption),
          SizedBox(height: 5),
          Text(formatter.format(this.value), style: valueStyle),
        ],
      ),
    );
  }
}
