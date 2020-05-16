import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19tracker/bloc/bloc.dart';
import 'package:covid19tracker/services/world_aggregated_service.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class WorldDataBloc extends Bloc<WorldDataEvent, WorldDataState> {
  final WorldAggregatedService service;

  WorldDataBloc({@required this.service});

  @override
  get initialState => WorldDataInitial();

  @override
  Stream<Transition<WorldDataEvent, WorldDataState>> transformEvents(
    Stream<WorldDataEvent> events,
    TransitionFunction<WorldDataEvent, WorldDataState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<WorldDataState> mapEventToState(WorldDataEvent event) async* {
    final currentState = state;
    if (event is WorldDataFetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is WorldDataInitial) {
          final worldData = await this.service.getData();
          yield WorldDataLoaded(worldData: worldData);
          return;
        }
      } catch (exception) {
        yield WorldDataFailure(exception);
      }
    }
  }

  bool _hasReachedMax(WorldDataState state) => state is WorldDataLoaded;
}
