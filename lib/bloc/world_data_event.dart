import 'package:equatable/equatable.dart';

abstract class WorldDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class WorldDataFetch extends WorldDataEvent {}