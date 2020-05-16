import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19tracker/bloc/bloc.dart';
import 'package:covid19tracker/services/news_service.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService service;

  NewsBloc({@required this.service});

  @override
  get initialState => NewsInitial();

  @override
  Stream<Transition<NewsEvent, NewsState>> transformEvents(
    Stream<NewsEvent> events,
    TransitionFunction<NewsEvent, NewsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    final currentState = state;
    if (event is NewsFetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is NewsInitial) {
          final news = await this.service.getData();
          yield NewsLoaded(news: news);
          return;
        }
      } catch (exception) {
        yield NewsFailure(exception);
      }
    }
  }

  bool _hasReachedMax(NewsState state) => state is NewsLoaded;
}
