import 'package:app/blocs/tab_menu/tab_menu_screen.dart';
import 'tab_menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabMenuBuilder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabMenuBuilderState();
}

class _TabMenuBuilderState extends State<TabMenuBuilder>{

  TabMenuBloc bloc;
  @override
  void initState() {
    bloc = TabMenuBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    bloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabMenuBloc>.value(
      value: bloc,
      child: TabMenuScreen(
        menuBloc: bloc,
      ),
    );
  }
}