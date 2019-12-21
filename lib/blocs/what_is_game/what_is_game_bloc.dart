import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:app/shared/repository/quiz_cards_repository.dart';
import 'package:flutter/material.dart';

import 'what_is_game_event.dart';
import 'what_is_game_state.dart';
import 'package:bloc/bloc.dart';

class WhatIsGameBloc extends Bloc<WhatIsGameEvent, WhatIsGameState>{

  final IntroShowedRepository introShowedRepository;
  final QuizCardsRepository quizCardsRepository;

  WhatIsGameBloc({@required this.introShowedRepository, @required this.quizCardsRepository});

  WhatIsGameState get initialState => introShowedRepository.isShowed(
    Screen.WhatIsGame
  ) ? GameLoading() : ShowIntro();

  @override
  Stream<WhatIsGameState> mapEventToState(WhatIsGameEvent event) async* {
    if (event is IntroIsOver){
      yield* _mapIntroOver(event);
    } else if (event is QuizCardsLoaded){
      yield* _mapCardsLoaded(event);
    } else if (event is UserIsReady){
      yield* _mapUserReady(event);
    } else if (event is UserAnswered){
      yield* _mapUserAnswered(event);
    }
  }

  Stream<WhatIsGameState> _mapUserAnswered(UserAnswered event)async*{
    var game = state as GameActive;
    var answers = game.answers;
    answers.add(game.cards[game.currentCard].answerIndex == event.answerIndex);
    var current = game.currentCard + 1;

    print(answers.length);
    print(game.cards.length);

    if (answers.length == game.cards.length){
      yield GameOver();
    } else {
      yield game.copyWith(
        answers: answers,
        currentCard: current
      );
    }
  }

  Stream<WhatIsGameState> _mapUserReady(UserIsReady event)async*{
    var game =  GameActive(
      cards: (state as WaitForBegin).cards,
    );
    print(game.answers);
    yield game;
  }

  Stream<WhatIsGameState> _mapCardsLoaded(QuizCardsLoaded event)async*{
    yield WaitForBegin(
      cards: event.cards
    );
  }

  Stream<WhatIsGameState> _mapIntroOver(IntroIsOver event)async*{
    yield GameLoading();
    quizCardsRepository.getCards().then((cards){
      add(QuizCardsLoaded(
        cards: cards
      ));
    });
  }

}
			