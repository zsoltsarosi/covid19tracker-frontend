import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/constants.dart';
import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/services/country_data_service.dart';
import 'package:covid19tracker/widgets/daily_chart.dart';
import 'package:covid19tracker/widgets/main_data_view.dart';
import 'package:flutter/material.dart';

class CountryDetail extends StatefulWidget {
  final CountryData country;

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

  Widget _buildContentView(Widget body) {
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
        body: body,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CountryData>>(
      future: this.getDataFuture,
      builder: (BuildContext context, AsyncSnapshot<List<CountryData>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _buildContentView(super.buildLoader());
        }
        if (snapshot.hasError) {
          return _buildContentView(super.buildError(snapshot.error, () {
            setState(() => this.getData());
          }));
        }
        if (snapshot.hasData) {
          var body = super.buildError("No data loaded", () {
            setState(() => this.getData());
          });
          if (snapshot.data != null && snapshot.data.length > 0) {
            body = SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(child: MainDataView(data: snapshot.data.last), flex: 1),
                  Expanded(
                      child: DailyChart(data: snapshot.data, colorScheme: Theme.of(context).colorScheme),
                      flex: 4),
                ],
              ),
            );
          }
          return _buildContentView(body);
        }

        return _buildContentView(super.buildNoData());
      },
    );
  }
}
