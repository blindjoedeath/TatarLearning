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
    }
  }

  Stream<WhatIsGameState> _mapCardsLoaded(QuizCardsLoaded event)async*{
    yield GameLoaded(
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
			