import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plinko_flame_game/bloc/plinko_bloc.dart';
import 'package:plinko_flame_game/plinko_game_screen.dart';
import 'package:plinko_flame_game/utils/screen_size.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initScreenSize(context: context);
    return BlocProvider(
      create: (context) => plinkoBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PlinkoGameScreen(),
      ),
    );
  }
}
