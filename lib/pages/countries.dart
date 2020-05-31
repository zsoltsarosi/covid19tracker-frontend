import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/bloc/country_data/bloc.dart';
import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/services/country_data_service.dart';
import 'package:covid19tracker/services/geolocation_service.dart';
import 'package:covid19tracker/widgets/country_data_list.dart';
import 'package:covid19tracker/widgets/country_data_view.dart';
import 'package:covid19tracker/widgets/country_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends FutureBuilderState<Countries> {
  GeoLocation _geoLocation;
  Future<GeoLocation> _opGetGeo;

  @override
  void initState() {
    super.initState();

    _opGetGeo = GeoLocationService().getGeoLocation();
    _opGetGeo.then((geoLocation) {
      _geoLocation = geoLocation;
    });
  }

  CountryData _getMyCountry(List<CountryData> countries) {
    if (_geoLocation == null) return null;

    var myCountry = countries.firstWhere((country) => country.countryIso2 == _geoLocation.countryIso2);
    return myCountry;
  }

  Widget _buildDataView(CountryDataLoaded state) {
    var dataExists = state.countryData != null && state.countryData.isNotEmpty;
    var dataWidget = state.exception != null
        ? super.buildError(
            state.exception, () => BlocProvider.of<CountryDataBloc>(context).add(CountryDataFetch()))
        : dataExists ? CountryDataList(data: state.countryData) : super.buildNoData();

    Widget myCountryWidget = Container(width: 0.0, height: 0.0);
    if (dataExists) {
      myCountryWidget = FutureBuilder<GeoLocation>(
        future: _opGetGeo,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var country = _getMyCountry(state.countryData);
            return CountryDataView(data: country);
          } else {
            return Container(width: 0.0, height: 0.0);
          }
        },
      );
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: CountrySearchField(),
        ),
        myCountryWidget,
        Expanded(child: dataWidget),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CountryDataBloc(service: CountryDataService())..add(CountryDataFetch()),
        child: BlocBuilder<CountryDataBloc, CountryDataState>(
          builder: (context, state) {
            if (state is CountryDataInitial) {
              if (state.exception != null)
                return super.buildError(
                    state.exception, () => BlocProvider.of<CountryDataBloc>(context).add(CountryDataFetch()));
              else
                return super.buildLoader();
            }

            if (state is CountryDataLoaded) {
              return _buildDataView(state);
            }

            return super.buildNoData();
          },
        ));
  }
}
