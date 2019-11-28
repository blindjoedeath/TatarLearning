import 'package:app/blocs/app/app_state.dart';
import 'package:app/blocs/tab_menu/tab_menu_builder.dart';
import 'package:app/blocs/weather/weather_builder.dart';
import 'package:app/blocs/welcome/welcome_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_bloc.dart';

class AppScreen extends StatelessWidget {

  final AppBloc appBloc;

  const AppScreen({@required this.appBloc}) : assert(appBloc != null);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder(
        bloc: appBloc,
        builder: (context, state){
          if (state is WelcomeUser){
            return WelcomeBuilder();
          }
          return TabMenuBuilder();
        },
      ),
    );
  }
}