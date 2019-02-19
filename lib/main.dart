import 'package:flutter/material.dart';
import 'package:waterlevel/bloc/bloc_provider.dart';
import 'package:waterlevel/bloc/wl_bloc.dart';
import 'package:waterlevel/screens/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: BlocProvider(
        bloc: WaterLevelBloc(),
        child: HomePage()),
    );
  }
}