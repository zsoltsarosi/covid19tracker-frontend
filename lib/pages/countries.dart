import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/bloc/bloc.dart';
import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/services/country_data_service.dart';
import 'package:covid19tracker/widgets/country_data_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends FutureBuilderState<Countries> {
  Widget _buildDataView(List<CountryData> data) {
    return CountryDataList(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CountryDataBloc(service: CountryDataService())..add(CountryDataFetch()),
        child: BlocBuilder<CountryDataBloc, CountryDataState>(
          builder: (context, state) {
            if (state is CountryDataLoaded) {
              if (state.countryData == null || state.countryData.isEmpty) {
                return super.buildNoData();
              }

              return _buildDataView(state.countryData);
            }

            if (state is CountryDataFailure) {
              return super.buildError(state.exception);
            }

            if (state is CountryDataInitial) {
              return super.buildLoader();
            }

            return super.buildNoData();
          },
        ));
  }
}
