import 'home_screen.dart';
import 'home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBuilder extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomeBuilderState();

}

class _HomeBuilderState extends State<HomeBuilder>{

  HomeBloc homeBloc;

  @override
  void initState() {
    homeBloc = HomeBloc(
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    homeBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>.value(
      value: homeBloc,
      child: HomeScreen(
        homeBloc: homeBloc,
      ),
    );
  }

}
			