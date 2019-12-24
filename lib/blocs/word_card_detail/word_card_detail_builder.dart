import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/word_card_repository.dart';

import 'word_card_detail_screen.dart';
import 'word_card_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordCardDetailBuilder extends StatefulWidget {

  final WordCard wordCard;

  const WordCardDetailBuilder({@required this.wordCard})
    : assert(wordCard != null);

  @override
  State<StatefulWidget> createState() => _WordCardDetailBuilderState();

}

class _WordCardDetailBuilderState extends State<WordCardDetailBuilder>{

  WordCardDetailBloc wordCardDetailBloc;

  @override
  void initState() {
    var repository = AppDependencyRepository.repositoriesContainer.get<WordCardRepository>();
    wordCardDetailBloc = WordCardDetailBloc(
      wordCardRepository: repository,
      wordCard: widget.wordCard
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    wordCardDetailBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WordCardDetailBloc>.value(
      value: wordCardDetailBloc,
      child: WordCardDetailScreen(
        wordCardDetailBloc: wordCardDetailBloc,
        wordCard: widget.wordCard,
      ),
    );
  }

}
			