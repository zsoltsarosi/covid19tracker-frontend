import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/model/country_data.dart';
import 'package:covid19tracker/services/country_data_service.dart';
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
    this.getDataFuture = this.service.getData();
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Widget _buildDataView(List<CountryData> data) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          actions: <Widget>[],
        ),
      ),
      body: SizedBox.expand(
        child: Container(child: Center(child: Text('Country detail ${widget.country.country}'))),
      ),
    );
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
