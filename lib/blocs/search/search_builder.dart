import 'package:app/shared/repository/search_history_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return SearchScreen(
      searchBloc: BlocProvider.of<SearchBloc>(context),
    );
  }

}
			