import 'package:app/blocs/search/search_bloc.dart';
import 'package:app/blocs/tab_menu/tab_menu_screen.dart';
import 'package:app/shared/repository/app_state_repository.dart';
import 'package:app/shared/repository/search_history_repository.dart';
import 'package:app/shared/repository/word_card_repository.dart';
import 'tab_menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabMenuBuilder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabMenuBuilderState();
}

class _TabMenuBuilderState extends State<TabMenuBuilder>{

  
  WordCardSearchRepository _wordCardSearchRepository;
  SearchBloc _searchBloc;
  TabMenuBloc _bloc;
  
  @override
  void initState() {
    _wordCardSearchRepository = WordCardSearchRepository();
    _searchBloc = SearchBloc(
      wordCardSearchRepository: _wordCardSearchRepository,
      searchHistoryRepository: SearchHistoryRepository(),
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WordCardSearchRepository>.value(value: _wordCardSearchRepository,)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TabMenuBloc>.value(value: _bloc,),
          BlocProvider<SearchBloc>.value(value: _searchBloc,),
        ],
        child: TabMenuScreen(
          menuBloc: _bloc,
        ),
      )
    );
  }
}