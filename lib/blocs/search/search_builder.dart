import 'package:app/shared/repository/card_repository.dart';

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
  CardSearchRepository _cardSearchRepository;

  @override
  void initState() {
    _cardSearchRepository = CardSearchRepository();
    _searchBloc = SearchBloc(
      cardSearchRepository: _cardSearchRepository
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
      builder: (context) => _cardSearchRepository, 
      child: BlocProvider<SearchBloc>.value(
        value: _searchBloc,
        child: SearchScreen(
          searchBloc: _searchBloc,
        ),
      )
    );
  }

}
			