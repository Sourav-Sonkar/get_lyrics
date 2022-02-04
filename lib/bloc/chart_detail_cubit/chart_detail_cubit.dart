import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_lyrics/network/models/chart_lyrics_response.dart';
import 'package:get_lyrics/network/models/request_status.dart';
import 'package:get_lyrics/network/models/single_track_detail.dart';
import 'package:get_lyrics/network/network_connection.dart';

part 'chart_detail_state.dart';

class ChartDetailCubit extends Cubit<ChartDetailState> {
  ChartDetailCubit(this._networkConnection) : super(ChartDetailInitial());
  final NetworkConnection _networkConnection;

  void getChartDetail(int chartId) async {
    if (state is ChartDetailLoading) {
      return;
    }
    emit(ChartDetailLoading());
    try {
      final chartDetail = await _networkConnection.getSingleChartTrack(chartId);
      if (chartDetail.status == RequestStatus.SUCCESS) {
        _networkConnection.getSingleChartLyrics(chartId).then((lyrics) {
          if (lyrics.status == RequestStatus.SUCCESS) {
            emit(ChartDetailLoaded(chartDetail.body, lyrics.body));
          } else {
            emit(ChartDetailFailed(lyrics.message ?? "Something went wrong"));
          }
        });
      } else {
        emit(ChartDetailFailed(chartDetail.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(const ChartDetailFailed("Failed to load chart detail"));
    }
  }
}
