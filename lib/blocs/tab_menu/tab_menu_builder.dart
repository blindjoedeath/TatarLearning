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

  final Future<void> heroTransition;

  const TabMenuBuilder({this.heroTransition});

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
      .register<WordCardRepository>((c) => WordCardRepository(),
                                          defaultMode: InjectMode.singleton);

    AppDependencyRepository
      .repositoriesContainer
      .register<WordCardRepository>((c) => WordCardRepository(),
                                          defaultMode: InjectMode.singleton);
    _searchBloc = SearchBloc(
      wordCardRepository: AppDependencyRepository
        .repositoriesContainer.get<WordCardRepository>(),
      searchHistoryRepository: _searchHistoryRepository,
    );

    _bloc = TabMenuBloc(
      searchBloc: _searchBloc,
      heroTransition: widget.heroTransition
    );

    AppDependencyRepository.blocsContainer
      .register<TabMenuBloc>((c) => _bloc);    

    super.initState();
  }
  

  @override
  void dispose() {
    super.dispose();
    AppDependencyRepository.repositoriesContainer.get<WordCardRepository>().dispose();
    AppDependencyRepository.repositoriesContainer.unregister<WordCardRepository>();
    AppDependencyRepository.blocsContainer.unregister<TabMenuBloc>();   
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