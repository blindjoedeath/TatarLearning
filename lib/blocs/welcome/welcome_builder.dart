import 'package:app/blocs/app/app_bloc.dart';
import 'package:app/blocs/welcome/welcome_bloc.dart';
import 'package:app/blocs/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class WelcomeBuilder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomeBuilderState();
}

class _WelcomeBuilderState extends State<WelcomeBuilder>{

  WelcomeBloc bloc;

  @override
  void initState() {
    bloc = WelcomeBloc(
      appBloc: BlocProvider.of<AppBloc>(context)
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
    return BlocProvider<WelcomeBloc>.value(
      value: bloc,
      child: WelcomeScreen(
        welcomeBloc: bloc,
      ),
    );
  }
}