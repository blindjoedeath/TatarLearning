import 'package:app/blocs/search/search_bloc.dart';
import 'package:app/blocs/tab_menu/tab_menu_screen.dart';
import 'package:app/shared/repository/search_history_repository.dart';
import 'package:app/shared/repository/word_card_repository.dart';
import 'package:hive/hive.dart';
import 'tab_menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabMenuBuilder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabMenuBuilderState();
}

class _TabMenuBuilderState extends State<TabMenuBuilder>{


  SearchBloc _searchBloc;
  TabMenuBloc _bloc;
  @override
  void initState() {
    _searchBloc = SearchBloc(
      wordCardSearchRepository: WordCardSearchRepository(),
      searchHistoryRepository: SearchHistoryRepository()
    );

    _bloc = TabMenuBloc(
      searchBloc: _searchBloc
    );

    super.initState();
  }
  

  @override
  void dispose() {
    super.dispose();
    _bloc?.close();
    _searchBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TabMenuBloc>.value(value: _bloc,),
        BlocProvider<SearchBloc>.value(value: _searchBloc,),
      ],
      child: TabMenuScreen(
        menuBloc: _bloc,
      ),
    );
  }
}