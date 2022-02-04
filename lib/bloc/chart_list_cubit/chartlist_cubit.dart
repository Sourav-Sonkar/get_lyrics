import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_lyrics/network/models/chart_tracks_list.dart';
import 'package:get_lyrics/network/models/request_status.dart';
import 'package:get_lyrics/network/network_connection.dart';
import 'package:meta/meta.dart';

part 'chartlist_state.dart';

class ChartlistCubit extends Cubit<ChartlistState> {
  ChartlistCubit(this._networkConnection) : super(ChartlistInitial());
  final NetworkConnection _networkConnection;

  void getChartlist() async {
    if (state is ChartlistLoading) {
      return;
    }
    emit(ChartlistLoading());
    try {
      final res = await _networkConnection.getChartTrackList();
      if (res.status == RequestStatus.SUCCESS) {
        emit(ChartlistLoaded(chartList: res.body));
      } else {
        emit(ChartlistFailed(errMsg: res.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(ChartlistFailed(errMsg: "Failed to fetch chart list"));
    }
  }
}
