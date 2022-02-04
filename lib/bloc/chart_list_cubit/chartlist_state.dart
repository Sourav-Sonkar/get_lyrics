part of 'chartlist_cubit.dart';

@immutable
abstract class ChartlistState extends Equatable {}

class ChartlistInitial extends ChartlistState {
  @override
  List<Object?> get props => [];
}

class ChartlistLoading extends ChartlistState {
  @override
  List<Object?> get props => [];
}

class ChartlistLoaded extends ChartlistState {
  final ChartTrackList? chartList;
  ChartlistLoaded({required this.chartList});

  @override
  List<Object?> get props => [chartList];
}

class ChartlistFailed extends ChartlistState {
  final String errMsg;
  ChartlistFailed({required this.errMsg});

  @override
  List<Object?> get props => [errMsg];
}
