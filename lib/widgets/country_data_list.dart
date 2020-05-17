import 'package:covid19tracker/helper/extension_methods.dart';
import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/screens/country_detail.dart';
import 'package:covid19tracker/widgets/figure_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class CountryDataList extends StatefulWidget {
  final List<CountryData> data;

  CountryDataList({Key key, @required this.data}) : super(key: key);

  @override
  _CountryDataListState createState() => _CountryDataListState();
}

class _CountryDataListState extends State<CountryDataList> {
  ScrollController _controller;
  var _onTop = true;

  var _sortIndex = 1;
  var _sortAsc = false;

  final NumberFormat formatter = NumberFormat();

  @override
  void initState() {
    super.initState();

    _controller = ScrollController()
      ..addListener(() {
        if (_controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange) {
          // bottom
          _triggerOnTopLeft();
        } else if (_controller.offset <= _controller.position.minScrollExtent &&
            !_controller.position.outOfRange) {
          // top
          _triggerOnTopReached();
        } else {
          // in between
          _triggerOnTopLeft();
        }
      });
  }

  void _triggerOnTopReached() {
    if (!_onTop) {
      setState(() {
        _onTop = true;
      });
    }
  }

  void _triggerOnTopLeft() {
    if (_onTop) {
      setState(() {
        _onTop = false;
      });
    }
  }

  String _countryFlag(String countryCode) {
    if (countryCode == null || countryCode.isEmpty) return "";

    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    int firstChar = countryCode.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = countryCode.codeUnitAt(1) - asciiOffset + flagOffset;

    String emoji = String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
    return emoji;
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.data;
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

    final labelTextStyle = textTheme.bodyText2;
    final valueTextStyle = textTheme.subtitle1;

    var confirmedStyle = valueTextStyle.copyWith(color: Theme.of(context).colorScheme.confirmed);
    var recoveredStyle = valueTextStyle.copyWith(color: Theme.of(context).colorScheme.recovered);
    var diedStyle = valueTextStyle.copyWith(color: Theme.of(context).colorScheme.died);

    final dataRows = [
      for (var item in data)
        DataRow(cells: [
          DataCell(
              Container(
                  child: Text("${_countryFlag(item.countryIso2)} ${item.country}", style: labelTextStyle)),
              onTap: () {
            _select(item);
          }),
          DataCell(Container(child: Text(formatter.format(item.confirmed), style: confirmedStyle)),
              onTap: () {
            _select(item);
          }),
          DataCell(Container(child: Text(formatter.format(item.recovered), style: recoveredStyle)),
              onTap: () {
            _select(item);
          }),
          DataCell(Container(child: Text(formatter.format(item.deaths), style: diedStyle)), onTap: () {
            _select(item);
          }),
        ])
    ];

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: _controller,
          child: FigureContainer(
            child: DataTable(
              sortColumnIndex: _sortIndex,
              sortAscending: _sortAsc,
              columnSpacing: 0,
              headingRowHeight: 40,
              columns: [
                DataColumn(label: Container(child: Text("Country")), onSort: _doSort),
                DataColumn(label: Container(child: Text("Confirmed")), numeric: true, onSort: _doSort),
                DataColumn(label: Container(child: Text("Recovered")), numeric: true, onSort: _doSort),
                DataColumn(label: Container(child: Text("Deaths")), numeric: true, onSort: _doSort),
              ],
              rows: dataRows,
            ),
          ),
        ),
        _buildBackToTop(),
      ],
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

  Widget _buildBackToTop() {
    if (_onTop) {
      return Container(width: 0.0, height: 0.0);
    } else {
      return Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 30, 30),
          child: FloatingActionButton(
            elevation: 10,
            onPressed: () {
              _controller.animateTo(0, curve: Curves.linear, duration: Duration(milliseconds: 100));
            },
            child: Icon(Icons.arrow_upward),
          ),
        ),
      );
    }
  }
}
