import 'package:colorlizer/colorlizer.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_lyrics/bloc/chart_detail_cubit/chart_detail_cubit.dart';
import 'package:get_lyrics/network/network_connection.dart';

class ChartDetailScreen extends StatelessWidget {
  const ChartDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/chart-detail';

  @override
  Widget build(BuildContext context) {
    final int? args = ModalRoute.of(context)!.settings.arguments! as int?;
    return BlocProvider(
      create: (context) => ChartDetailCubit(context.read<NetworkConnection>())
        ..getChartDetail(args ?? 0),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Chart Detail'),
            centerTitle: true,
          ),
          body: BlocConsumer<ChartDetailCubit, ChartDetailState>(
            listener: (context, state) {
              if (state is ChartDetailFailed) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ));
              }
            },
            builder: (context, state) {
              if (state is ChartDetailInitial || state is ChartDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ChartDetailLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FlipCard(
                    fill: Fill.fillBack,
                    // Fill the back side of the card to make in the same size as the front.
                    direction: FlipDirection.HORIZONTAL, // default
                    front: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorLizer().getRandomColors(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  "Track Name:${state.chartDetail?.message!.body!.track!.trackName}"),
                              Text(
                                  "Album Name:${state.chartDetail?.message!.body!.track!.albumName}"),
                              Text(
                                  "Artist Namme:${state.chartDetail?.message!.body!.track!.artistName}"),
                              Text(
                                  "Ratings:${state.chartDetail?.message!.body!.track!.trackRating}"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Click here to get Lyrics",
                                  ),
                                  Icon(Icons.double_arrow)
                                ],
                              )
                            ]),
                      ),
                    ),
                    back: Container(
                      decoration: BoxDecoration(
                        color: ColorLizer().getRandomColors(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text("Lyrics"),
                                const SizedBox(height: 20),
                                Text(state.chartLyrics?.message!.body!.lyrics!
                                        .lyricsBody ??
                                    "No Lyrics Found"),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Click here to get Chart detail",
                                    ),
                                    Icon(Icons.double_arrow)
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Center(
                child: TextButton(
                    onPressed: () {
                      context
                          .read<ChartDetailCubit>()
                          .getChartDetail(args ?? 0);
                    },
                    child: const Text('Retry')),
              );
            },
          )),
    );
  }
}
