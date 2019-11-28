import 'search_screen.dart';
import 'search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBuilder extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SearchBuilderState();

}

class _SearchBuilderState extends State<SearchBuilder>{

  SearchBloc searchBloc;

  @override
  void initState() {
    searchBloc = SearchBloc(
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>.value(
      value: searchBloc,
      child: SearchScreen(
        searchBloc: searchBloc,
      ),
    );
  }

}
			