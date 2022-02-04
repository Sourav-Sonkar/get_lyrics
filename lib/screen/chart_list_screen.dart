import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_lyrics/bloc/chart_list_cubit/chartlist_cubit.dart';
import 'package:get_lyrics/network/network_connection.dart';
import 'package:get_lyrics/screen/chart_detail_screen.dart';

class ChartListScreen extends StatelessWidget {
  const ChartListScreen({Key? key}) : super(key: key);
  static const routeName = '/chart-list';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChartlistCubit(context.read<NetworkConnection>())..getChartlist(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chart List'),
          centerTitle: true,
          elevation: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: BlocConsumer<ChartlistCubit, ChartlistState>(
            listener: (context, state) {
              if (state is ChartlistFailed) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(state.errMsg),
                    backgroundColor: Colors.red,
                  ));
              }
            },
            builder: (context, state) {
              if (state is ChartlistInitial || state is ChartlistLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ChartlistLoaded) {
                var colorlizer = ColorLizer();
                return ListView.builder(
                  itemBuilder: (c, i) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ChartDetailScreen.routeName,
                          arguments: state.chartList?.message?.body
                              ?.trackList![i].track?.trackId,
                        );
                      },
                      leading: Icon(
                        CupertinoIcons.music_note_2,
                        color: colorlizer.getRandomColors(),
                      ),
                      //trailing: const Icon(CupertinoIcons.heart),
                      title: Text(state.chartList?.message?.body?.trackList![i]
                              .track?.trackName ??
                          ""),
                      subtitle: Text(state.chartList?.message?.body
                              ?.trackList![i].track?.artistName ??
                          ""),
                    );
                  },
                  itemCount: state.chartList?.message?.body?.trackList?.length,
                );
              }
              return Center(
                child: TextButton(
                    onPressed: () {
                      context.read<ChartlistCubit>().getChartlist();
                    },
                    child: const Text('Retry')),
              );
            },
          ),
        ),
      ),
    );
  }
}
