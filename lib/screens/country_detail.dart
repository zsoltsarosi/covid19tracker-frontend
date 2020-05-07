import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/constants.dart';
import 'package:covid19tracker/model/country_data.dart';
import 'package:covid19tracker/services/country_data_service.dart';
import 'package:covid19tracker/widgets/daily_chart.dart';
import 'package:covid19tracker/widgets/single_day_view.dart';
import 'package:flutter/material.dart';
import 'package:covid19tracker/model/country_data.dart' as model;

class CountryDetail extends StatefulWidget {
  final model.CountryData country;

  CountryDetail({Key key, @required this.country}) : super(key: key);

  @override
  _CountryDetailState createState() => _CountryDetailState();
}

class _CountryDetailState extends FutureBuilderState<CountryDetail> {
  final CountryDataService service = CountryDataService();
  Future<List<CountryData>> getDataFuture;

  void getData() {
    this.getDataFuture = this.service.getDetail(widget.country.country);
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Widget _buildDataView(List<CountryData> data) {
    return Stack(children: [
      Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [
            kMainBgGradient1,
            kMainBgGradient2,
          ],
          stops: [0.0, 1.0],
        )),
      ),
      Scaffold(
        backgroundColor: const Color(0x00000000),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            title: Text(widget.country.country),
            actions: <Widget>[],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: SingleDayView(data: data.last), flex: 1),
            Expanded(child: DailyChart(data: data, colorScheme: Theme.of(context).colorScheme), flex: 4),
          ],
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CountryData>>(
      future: this.getDataFuture,
      builder: (BuildContext context, AsyncSnapshot<List<CountryData>> snapshot) {
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
