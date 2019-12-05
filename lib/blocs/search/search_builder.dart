import 'package:app/shared/repository/word_card_repository.dart';

import 'search_screen.dart';
import 'search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBuilder extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SearchBuilderState();

}

class _SearchBuilderState extends State<SearchBuilder>{

  SearchBloc _searchBloc;
  WordCardSearchRepository _wordCardSearchRepository;

  @override
  void initState() {
    _wordCardSearchRepository = WordCardSearchRepository();
    _searchBloc = SearchBloc(
      wordCardSearchRepository: _wordCardSearchRepository
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      builder: (context) => _wordCardSearchRepository, 
      child: BlocProvider<SearchBloc>.value(
        value: _searchBloc,
        child: SearchScreen(
          searchBloc: _searchBloc,
        ),
      )
    );
  }

}
			