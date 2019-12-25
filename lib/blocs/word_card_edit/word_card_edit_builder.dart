import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/dictionary_repository.dart';

import 'word_card_edit_screen.dart';
import 'word_card_edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordCardEditBuilder extends StatefulWidget {

  final WordCard wordCard;

  const WordCardEditBuilder({@required this.wordCard});

  @override
  State<StatefulWidget> createState() => _WordCardEditBuilderState();

}

class _WordCardEditBuilderState extends State<WordCardEditBuilder>{

  WordCardEditBloc wordCardEditBloc;

  @override
  void initState() {
    wordCardEditBloc = WordCardEditBloc(
      dictionaryRepository: AppDependencyRepository.repositoriesContainer.get<DictionaryRepository>()
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    wordCardEditBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WordCardEditBloc>.value(
      value: wordCardEditBloc,
      child: WordCardEditScreen(
        wordCard: widget.wordCard,
        wordCardEditBloc: wordCardEditBloc,
      ),
    );
  }

}
			