import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/helper/extension_methods.dart';
import 'package:covid19tracker/model/country_data.dart';
import 'package:covid19tracker/screens/country_detail.dart';
import 'package:covid19tracker/services/country_data_service.dart';
import 'package:flutter/material.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends FutureBuilderState<Countries> {
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

    TextTheme textTheme = Theme.of(context).textTheme;
    var confirmedStyle = textTheme.caption.copyWith(color: Theme.of(context).colorScheme.confirmed);
    var recoveredStyle = textTheme.caption.copyWith(color: Theme.of(context).colorScheme.recovered);
    var diedStyle = textTheme.caption.copyWith(color: Theme.of(context).colorScheme.died);

    final dataRows = [
      for (var item in data)
        DataRow(cells: [
          DataCell(Container(child: Text(item.country)), onTap: () {
            _select(item);
          }),
          DataCell(Container(child: Text("${item.confirmed}", style: confirmedStyle)), onTap: () {
            _select(item);
          }),
          DataCell(Container(child: Text("${item.recovered}", style: recoveredStyle)), onTap: () {
            _select(item);
          }),
          DataCell(Container(child: Text("${item.deaths}", style: diedStyle)), onTap: () {
            _select(item);
          }),
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

  void _select(CountryData country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetail(country: country),
      ),
    );
  }

  void _doSort(columnIndex, sortAscending) {
    _sortIndex = columnIndex;
    _sortAsc = sortAscending;
    setState(() {});
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
