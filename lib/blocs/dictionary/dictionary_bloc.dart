import 'package:app/shared/repository/dictionary_repository.dart';
import 'package:app/shared/repository/user_repository.dart';
import 'package:flutter/material.dart';

import 'dictionary_event.dart';
import 'dictionary_state.dart';
import 'package:bloc/bloc.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState>{

  final UserRepository userRepository;
  final DictionaryRepository dictionaryRepository;

  DictionaryBloc({@required this.userRepository, @required this.dictionaryRepository}){
    dictionaryRepository.get().then((cards){
      add(CardsLoadedEvent(
        cards: cards
      ));
    });
  }

  DictionaryState get initialState => Loading();

  @override
  Stream<DictionaryState> mapEventToState(DictionaryEvent event) async* {
    if (event is CardsLoadedEvent){
      yield* _mapCardsLoaded(event);
    } else if (event is CardRemoved){
      yield* _mapCardRemoved(event);
    }
  }

    Stream<DictionaryState> _mapCardRemoved(CardRemoved event) async* {
      var cards = (state as CardsLoaded).cards;
      cards.removeAt(event.index);
      yield CardsLoaded(
        cards: cards
      );
    }

  Stream<DictionaryState> _mapCardsLoaded(CardsLoadedEvent event) async* {
    yield CardsLoaded(
      cards: event.cards
    );
  }

}
			