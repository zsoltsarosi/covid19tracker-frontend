import 'package:covid19tracker/model/model.dart';
import 'package:equatable/equatable.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsFailure extends NewsState {
  final Object exception;
  const NewsFailure(this.exception);
}

class NewsLoaded extends NewsState {
  final List<News> news;

  const NewsLoaded({this.news,});

  NewsLoaded copyWith({
    List<News> news,
  }) {
    return NewsLoaded(
      news: news ?? this.news,
    );
  }

  @override
  List<Object> get props => [news];

  @override
  String toString() => 'NewsLoaded { data points: ${this.news.length}';
}
