import 'package:covid19tracker/model/country_data.dart';
import 'package:covid19tracker/services/country_data_service.dart';
import 'package:flutter/material.dart';
import 'package:covid19tracker/model/country_data.dart' as model;

class CountryDetail extends StatefulWidget {
  static const routeName = '/country';
  final model.CountryData country;

  CountryDetail({Key key, @required this.country}) : super(key: key);

  @override
  _CountryDetailState createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
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

  Widget _buildLoader() {
    return Center(
        child: SizedBox(
      child: CircularProgressIndicator(),
      width: 20,
      height: 20,
    ));
  }

  Widget _buildError(Object error) {
    return Column(
      children: <Widget>[
        Text('Error loading data'),
        IconButton(
            icon: Icon(Icons.refresh, color: Colors.black, size: 20),
            onPressed: () {
              this.getData();
              setState(() {});
            }),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
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

  Widget _buildNoData() {
    return Container(width: 0.0, height: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CountryData>>(
      future: this.getDataFuture,
      builder: (BuildContext context, AsyncSnapshot<List<CountryData>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _buildLoader();
        }
        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        }
        if (snapshot.hasData) {
          return _buildDataView(snapshot.data);
        }

        return _buildNoData();
      },
    );
  }
}
