import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19tracker/bloc/bloc.dart';
import 'package:covid19tracker/services/country_data_service.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class CountryDataBloc extends Bloc<CountryDataEvent, CountryDataState> {
  final CountryDataService service;

  CountryDataBloc({@required this.service});

  @override
  get initialState => CountryDataInitial();

  @override
  Stream<Transition<CountryDataEvent, CountryDataState>> transformEvents(
    Stream<CountryDataEvent> events,
    TransitionFunction<CountryDataEvent, CountryDataState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<CountryDataState> mapEventToState(CountryDataEvent event) async* {
    final currentState = state;
    if (event is CountryDataFetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is CountryDataInitial) {
          final countryData = await this.service.getData();
          yield CountryDataLoaded(countryData: countryData);
          return;
        }
      } catch (exception) {
        yield CountryDataFailure(exception);
      }
    }
  }

  bool _hasReachedMax(CountryDataState state) => state is CountryDataLoaded;
}
