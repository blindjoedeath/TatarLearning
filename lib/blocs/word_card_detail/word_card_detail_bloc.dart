import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/repository/word_card_repository.dart';
import 'package:flutter/material.dart';

import 'word_card_detail_event.dart';
import 'word_card_detail_state.dart';
import 'package:bloc/bloc.dart';

class WordCardDetailBloc extends Bloc<WordCardDetailEvent, WordCardDetailState>{

  final WordCardRepository wordCardRepository;
  final WordCard wordCard;

  WordCardDetailBloc({@required this.wordCardRepository, @required this.wordCard}) 
    : assert(wordCardRepository != null),
      assert(wordCard != null);

  WordCardDetailState get initialState => WordCardDetailState(
    wordAdded: wordCardRepository.containsLocal(wordCard)
  );

  @override
  Stream<WordCardDetailState> mapEventToState(WordCardDetailEvent event) async* {
    if (event is WordAddedStateChanged){
      yield state.copyWith(wordAdded: !state.wordAdded);
      if (state.wordAdded){
        await wordCardRepository.addLocalIfNotContains(wordCard);
      } else {
        await wordCardRepository.deleteLocalIfContains(wordCard);
      }
    }
  }

}
			