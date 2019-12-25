import 'package:app/shared/repository/dictionary_repository.dart';
import 'package:flutter/material.dart';

import 'word_card_edit_event.dart';
import 'word_card_edit_state.dart';
import 'package:bloc/bloc.dart';

class WordCardEditBloc extends Bloc<WordCardEditEvent, WordCardEditState>{

  final DictionaryRepository dictionaryRepository;

  WordCardEditBloc({@required this.dictionaryRepository});

  WordCardEditState get initialState => null;

  @override
  Stream<WordCardEditState> mapEventToState(WordCardEditEvent event) async* {
    if (event is Save){
      dictionaryRepository.update(event.card);
    }
  }

}
			