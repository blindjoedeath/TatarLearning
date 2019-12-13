import 'package:app/blocs/app/app_screen.dart';
import 'package:app/shared/repository/app_state_repository.dart';
import 'package:app/shared/repository/welcomed_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_bloc.dart';

class AppBuilder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppBuilderState();

}

class _AppBuilderState extends State<AppBuilder>{

  AppBloc bloc;
  WelcomedRepository welcomedRepository;

  @override
  void initState() {
    welcomedRepository = WelcomedRepository();
    bloc = AppBloc(
      welcomedRepository: welcomedRepository
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    bloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    var appScreen = AppScreen(
      appBloc: bloc,
    );
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WelcomedRepository>(builder: (context) => welcomedRepository,),
        RepositoryProvider<AppStateRepository>(builder: (context) => appScreen),
      ],
      child: BlocProvider<AppBloc>.value(
        value: bloc,
        child: appScreen
      ),
    );
  }
}