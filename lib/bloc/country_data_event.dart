import 'package:equatable/equatable.dart';

abstract class CountryDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CountryDataFetch extends CountryDataEvent 
{
  final String filter;
  CountryDataFetch({this.filter});
}