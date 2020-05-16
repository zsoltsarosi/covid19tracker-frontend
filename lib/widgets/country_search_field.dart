import 'package:covid19tracker/bloc/bloc.dart';
import 'package:covid19tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountrySearchField extends StatefulWidget {
  @override
  _CountrySearchFieldState createState() => _CountrySearchFieldState();
}

class _CountrySearchFieldState extends State<CountrySearchField> {
  final TextEditingController _textController = TextEditingController();

  void _onSearch() {
    BlocProvider.of<CountryDataBloc>(context).add(CountryDataFetch(filter: _textController.value.text));
    // FocusScope.of(context).requestFocus(FocusNode());
    // WidgetsBinding.instance.addPostFrameCallback((_) => _textController.clear());
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      controller: _textController,
      // onSubmitted: (value) => _onSearch(value, true),
      onChanged: (value) => _onSearch(),
      style: TextStyle(
        fontSize: 20.0,
        color: Theme.of(context).primaryColor,
        decoration: TextDecoration.none,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: kFigureBackground,
        suffixIcon: IconButton(
          onPressed: () {
            _textController.clear();
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            _onSearch();
          },
          icon: Icon(Icons.cancel),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        prefixIcon: const Icon(Icons.search),
        hintText: "Search...",
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 32.0),
            borderRadius: BorderRadius.circular(15.0)),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(color: Colors.white, width: 32.0),
        //   borderRadius: BorderRadius.circular(15.0),
        // ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
