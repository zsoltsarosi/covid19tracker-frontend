import 'package:covid19tracker/model/model.dart';
import 'package:equatable/equatable.dart';

abstract class CountryDataState extends Equatable {
  const CountryDataState();

  @override
  List<Object> get props => [];
}

class CountryDataInitial extends CountryDataState {
  final Object exception;
  const CountryDataInitial({this.exception});

  CountryDataInitial copyWith({
    Object exception,
  }) {
    return CountryDataInitial(
      exception: exception ?? this.exception,
    );
  }
}

class CountryDataLoaded extends CountryDataState {
  final String filter;
  final List<CountryData> countryData;
  final Object exception;

  const CountryDataLoaded({this.filter, this.countryData, this.exception});

  CountryDataLoaded copyWith({
    String filter,
    List<CountryData> countryData,
    Object exception,
  }) {
    return CountryDataLoaded(
      filter: filter ?? this.filter,
      countryData: countryData ?? this.countryData,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object> get props => [filter, countryData, exception];

  @override
  String toString() => 'CountryDataLoaded { filter: $filter, data points: ${countryData.length}';
}
