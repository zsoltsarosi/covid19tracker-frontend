import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/bloc/bloc.dart';
import 'package:covid19tracker/services/country_data_service.dart';
import 'package:covid19tracker/widgets/country_data_list.dart';
import 'package:covid19tracker/widgets/country_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends FutureBuilderState<Countries> {
  Widget _buildDataView(CountryDataLoaded state) {
    print('data countries count: ${state.countryData?.length}');

    var dataWidget = state.exception != null
        ? super.buildError(state.exception)
        : state.countryData == null || state.countryData.isEmpty
            ? super.buildNoData()
            : CountryDataList(data: state.countryData);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: CountrySearchField(),
        ),
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
                return super.buildError(state.exception);
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
