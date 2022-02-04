import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_lyrics/network/network_connection.dart';
import 'package:get_lyrics/screen/chart_detail_screen.dart';
import 'package:get_lyrics/screen/chart_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NetworkConnection(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: ColorLizer().getRandomColors() as MaterialColor,
        ),
        home: const ChartListScreen(),
        routes: {
          ChartListScreen.routeName: (context) => const ChartListScreen(),
          ChartDetailScreen.routeName: (context) => const ChartDetailScreen(),
        },
      ),
    );
  }
}
