import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_lyrics/network/models/chart_lyrics_response.dart';
import 'package:get_lyrics/network/models/chart_tracks_list.dart';
import 'package:get_lyrics/network/models/request_status.dart';
import 'package:get_lyrics/network/models/single_track_detail.dart';
import 'package:http/http.dart' as http;

class NetworkConnection {
  static const _baseUrl = "api.musixmatch.com";

  NetworkConnection({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();
  final http.Client _httpClient;
  static const apiKey = "2d782bc7a52a41ba2fc1ef05b9cf40d7";

  Future<RequestStatus<ChartTrackList?>> getChartTrackList() async {
    final uri =
        Uri.https(_baseUrl, "/ws/1.1/chart.tracks.get", {"apikey": apiKey});
    try {
      final response = await _httpClient.get(uri);
      if (response.statusCode == 200) {
        return RequestStatus(RequestStatus.SUCCESS, "",
            ChartTrackList.fromJson(jsonDecode(response.body)));
      } else {
        return _checkErrorCode(response);
      }
    } catch (e) {
      return _commonCatchBlock(e);
    }
  }

  Future<RequestStatus<SingleTrackDetail?>> getSingleChartTrack(
      int trackId) async {
    final uri = Uri.https(
        _baseUrl, "/ws/1.1/track.get", {"apikey": apiKey, "track_id": trackId.toString()});
    try {
      final response = await _httpClient.get(uri);
      if (response.statusCode == 200) {
        return RequestStatus(RequestStatus.SUCCESS, "",
            SingleTrackDetail.fromJson(jsonDecode(response.body)));
      } else {
        return _checkErrorCode(response);
      }
    } catch (e) {
      return _commonCatchBlock(e);
    }
  }

  Future<RequestStatus<ChartLyricsResponse?>> getSingleChartLyrics(
      int trackId) async {
    final uri = Uri.https(
        _baseUrl, "/ws/1.1/track.lyrics.get", {"apikey": apiKey, "track_id": trackId.toString()});
    try {
      final response = await _httpClient.get(uri);
      if (response.statusCode == 200) {
        return RequestStatus(RequestStatus.SUCCESS, "",
            ChartLyricsResponse.fromJson(jsonDecode(response.body)));
      } else {
        return _checkErrorCode(response);
      }
    } catch (e) {
      return _commonCatchBlock(e);
    }
  }

  /// To be used inside else block of non 200 response codes
  /// It returns requestStatus with appropriate message
  /// according to the response error codes
  RequestStatus<T> _checkErrorCode<T>(http.Response response) {
    //print(response.statusCode);
    //print(response.reasonPhrase);
    if (response.statusCode == 400) {
      String msg = jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['status'] ??
          jsonDecode(response.body)['detail'] ??
          jsonDecode(response.body)['error'] ??
          'Something went wrong';
      return RequestStatus<T>(RequestStatus.FAILURE, msg, null);
    } else if (response.statusCode == 401) {
      //print(response.body);
      String msg =
          jsonDecode(response.body)['detail'] ?? 'Something went wrong';
      return RequestStatus<T>(RequestStatus.FAILURE, msg, null);
    } else {
      //print("Status Code: ${response.statusCode}");
      //print("Reason phase: ${response.reasonPhrase}");
      throw Exception("Response code is ${response.statusCode}");
    }
  }

  /// Used inside every catch block of api call
  /// It returns Failed [RequestStatus] with appropriate message
  RequestStatus<T> _commonCatchBlock<T>(e) {
    if (e is TimeoutException || e is SocketException) {
      return RequestStatus<T>(
          RequestStatus.FAILURE, 'Check internet connection', null);
    }
    //print(e);
    return RequestStatus<T>(
        RequestStatus.FAILURE, 'Something went wrong', null);
  }
}
