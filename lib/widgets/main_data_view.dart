import 'package:covid19tracker/helper/extension_methods.dart';
import 'package:covid19tracker/model/single_day_data.dart';
import 'package:covid19tracker/widgets/figure_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainDataView extends StatefulWidget {
  final SingleDayData data;
  final double increaseRate;

  MainDataView({Key key, this.increaseRate, @required this.data}) : super(key: key);

  @override
  _MainDataViewState createState() => _MainDataViewState();
}

class _MainDataViewState extends State<MainDataView> {
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
        style: textTheme.subtitle2.copyWith(fontSize: 10.0, fontWeight: FontWeight.normal));
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return FigureContainer(
      child: Column(
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
                    style: textTheme.subtitle2.copyWith(fontSize: 10.0, fontWeight: FontWeight.normal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MainData extends StatelessWidget {
  final NumberFormat formatter = NumberFormat();

  final String title;
  final int value;
  final Color color;

  MainData({this.title, this.value, this.color});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    var valueStyle = textTheme.headline6.copyWith(color: color);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Circle(color: this.color),
          Text(formatter.format(this.value), style: valueStyle),
          Text(this.title, style: textTheme.caption)          
        ],
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final Color color;
  Circle({this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(.26),
      ),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.transparent, border: Border.all(color: color, width: 2)),
      ),
    );
  }
}
