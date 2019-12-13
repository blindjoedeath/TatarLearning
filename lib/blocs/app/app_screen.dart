import 'dart:async';

import 'package:app/blocs/app/app_event.dart';
import 'package:app/blocs/app/app_state.dart';
import 'package:app/blocs/tab_menu/tab_menu_builder.dart';
import 'package:app/blocs/welcome/welcome_builder.dart';
import 'package:app/shared/repository/app_state_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_bloc.dart';

class AppScreen extends StatelessWidget with  WidgetsBindingObserver implements AppStateRepository{

  final AppBloc appBloc;
  
  AppScreen({@required this.appBloc}) : assert(appBloc != null);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    return MaterialApp(
      home: BlocBuilder<AppBloc, AppState>(
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    _controller.sink.add(state);
  }

  AppLifecycleState _appLifecycleState;

  StreamController<AppLifecycleState> _controller = StreamController();

    @override
  AppLifecycleState get appState => _appLifecycleState;

  @override
  Stream<AppLifecycleState> get appStateStream => _controller.stream.asBroadcastStream();
}
