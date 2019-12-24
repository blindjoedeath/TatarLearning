import 'package:app/shared/entity/game_result.dart';
import 'package:app/shared/repository/word_card_repository.dart';
import 'package:flutter/material.dart';

import 'game_overview_event.dart';
import 'game_overview_state.dart';
import 'package:bloc/bloc.dart';

class GameOverviewBloc extends Bloc<GameOverviewEvent, GameOverviewState>{

  final GameResult gameResult;

  final WordCardRepository wordCardRepository;

  GameOverviewBloc({@required this.gameResult, @required this.wordCardRepository});

  GameOverviewState get initialState => GameOverviewState(
    gameResult: gameResult,
    isWordAdded: List<bool>.generate(
      gameResult.quizCards.length,
      (i) => wordCardRepository.containsLocal(gameResult.getCard(i))
    )
  );

  @override
  Stream<GameOverviewState> mapEventToState(GameOverviewEvent event) async* {
    if (event is WordAddedStateChanged){
      yield* _mapWordAdded(event);
    }
  }

  Stream<GameOverviewState> _mapWordAdded(WordAddedStateChanged event) async* {
    var added = state.isWordAdded.toList();
    added[event.index] = !added[event.index];
    
    yield state.copyWith(
      isWordAdded: added
    );

    var card = gameResult.getCard(event.index);
    if (added[event.index]){
      await wordCardRepository.addLocalIfNotContains(card);
    } else{
      await wordCardRepository.deleteLocalIfContains(card);
    }
  }

}
			