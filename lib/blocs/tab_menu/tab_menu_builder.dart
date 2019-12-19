import 'package:app/blocs/search/search_bloc.dart';
import 'package:app/blocs/tab_menu/tab_menu_screen.dart';
import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/app_state_repository.dart';
import 'package:app/shared/repository/search_history_repository.dart';
import 'package:app/shared/repository/word_card_repository.dart';
import 'package:dioc/dioc.dart';
import 'tab_menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabMenuBuilder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabMenuBuilderState();
}

class _TabMenuBuilderState extends State<TabMenuBuilder>{

  SearchHistoryRepository _searchHistoryRepository;
  SearchBloc _searchBloc;
  TabMenuBloc _bloc;
  
  @override
  void initState() {
    _searchHistoryRepository = SearchHistoryRepository();
    AppDependencyRepository
      .repositoriesContainer
      .register<WordCardSearchRepository>((c) => WordCardSearchRepository(),
                                          defaultMode: InjectMode.singleton);
    _searchBloc = SearchBloc(
      wordCardSearchRepository: AppDependencyRepository
        .repositoriesContainer.get<WordCardSearchRepository>(),
      searchHistoryRepository: _searchHistoryRepository,
    );

    _bloc = TabMenuBloc(
      searchBloc: _searchBloc
    );

    super.initState();
  }
  

  @override
  void dispose() {
    super.dispose();
    AppDependencyRepository.repositoriesContainer.get<WordCardSearchRepository>().dispose();
    AppDependencyRepository.repositoriesContainer.unregister<WordCardSearchRepository>();
    _searchHistoryRepository.dispose();
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