import 'package:covid19tracker/model/country_data.dart';
import 'package:covid19tracker/services/country_data_service.dart';
import 'package:flutter/material.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  final CountryDataService service = CountryDataService();
  Future<List<CountryData>> getDataFuture;

  var _sortIndex = 0;
  var _sortAsc = true;

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
    data.sort((a, b) {
      switch (_sortIndex) {
        case 0:
          return a.country.compareTo(b.country);
        case 1:
          return a.confirmed.compareTo(b.confirmed);
        case 2:
          return a.recovered.compareTo(b.recovered);
        case 3:
          return a.deaths.compareTo(b.deaths);
        default:
          return a.country.compareTo(b.country);
      }
    });
    if (!_sortAsc) data = data.reversed.toList();

    final dataRows = [
      for (var item in data)
        DataRow(cells: [
          DataCell(Container(child: Text(item.country))),
          DataCell(Container(child: Text("${item.confirmed}"))),
          DataCell(Container(child: Text("${item.recovered}"))),
          DataCell(Container(child: Text("${item.deaths}"))),
        ])
    ];

    return SingleChildScrollView(
      child: DataTable(
        sortColumnIndex: _sortIndex,
        sortAscending: _sortAsc,
        columnSpacing: 0,
        headingRowHeight: 36,
        dataRowHeight: 36,
        columns: [
          DataColumn(label: Container(child: Text("Country")), onSort: _doSort),
          DataColumn(label: Container(child: Text("Confirmed")), numeric: true, onSort: _doSort),
          DataColumn(label: Container(child: Text("Recovered")), numeric: true, onSort: _doSort),
          DataColumn(label: Container(child: Text("Deaths")), numeric: true, onSort: _doSort),
        ],
        rows: dataRows,
      ),
    );
  }

  void _doSort(columnIndex, sortAscending) {
    _sortIndex = columnIndex;
    _sortAsc = sortAscending;
    setState(() {});
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
