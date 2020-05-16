import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19tracker/bloc/country_data/bloc.dart';
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
    if (event is CountryDataFetch) {
      try {
        final countryData = await this.service.getData(event.filter);
        yield CountryDataLoaded(filter: event.filter, countryData: countryData);
        return;
      } catch (exception) {
        if (currentState is CountryDataInitial) {
          yield currentState.copyWith(exception: exception);
          return;
        }
        if (currentState is CountryDataLoaded) {
          yield currentState.copyWith(exception: exception);
          return;
        }
      }
    }
  }
}
