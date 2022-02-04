part of 'chart_detail_cubit.dart';

abstract class ChartDetailState extends Equatable {
  const ChartDetailState();

  @override
  List<Object> get props => [];
}

class ChartDetailInitial extends ChartDetailState {}
class ChartDetailLoading extends ChartDetailState {}
class ChartDetailLoaded extends ChartDetailState {
  final SingleTrackDetail? chartDetail;
  final ChartLyricsResponse? chartLyrics;

  const ChartDetailLoaded(this.chartDetail, this.chartLyrics);
}
class ChartDetailFailed extends ChartDetailState {
  final String message;

  const ChartDetailFailed(this.message);
}
