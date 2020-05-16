import 'package:covid19tracker/model/model.dart';
import 'package:equatable/equatable.dart';

abstract class WorldDataState extends Equatable {
  const WorldDataState();

  @override
  List<Object> get props => [];
}

class WorldDataInitial extends WorldDataState {}

class WorldDataFailure extends WorldDataState {
  final Object exception;
  const WorldDataFailure(this.exception);
}

class WorldDataLoaded extends WorldDataState {
  final List<WorldAggregated> worldData;

  const WorldDataLoaded({
    this.worldData,
  });

  WorldDataLoaded copyWith({
    List<WorldAggregated> worldData,
  }) {
    return WorldDataLoaded(
      worldData: worldData ?? this.worldData,
    );
  }

  @override
  List<Object> get props => [worldData];

  @override
  String toString() => 'WorldDataLoaded { data points: ${worldData.length}';
}
