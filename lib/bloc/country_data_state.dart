import 'package:covid19tracker/model/model.dart';
import 'package:equatable/equatable.dart';

abstract class CountryDataState extends Equatable {
  const CountryDataState();

  @override
  List<Object> get props => [];
}

class CountryDataInitial extends CountryDataState {}

class CountryDataFailure extends CountryDataState {
  final Object exception;
  const CountryDataFailure(this.exception);
}

class CountryDataLoaded extends CountryDataState {
  final List<CountryData> countryData;

  const CountryDataLoaded({
    this.countryData,
  });

  CountryDataLoaded copyWith({
    List<CountryData> countryData,
  }) {
    return CountryDataLoaded(
      countryData: countryData ?? this.countryData,
    );
  }

  @override
  List<Object> get props => [countryData];

  @override
  String toString() => 'CountryDataLoaded { data points: ${countryData.length}';
}
