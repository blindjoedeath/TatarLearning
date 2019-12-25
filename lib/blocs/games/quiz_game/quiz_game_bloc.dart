import 'package:app/blocs/games/quiz_game/quiz_game_configuration.dart';
import 'package:app/shared/entity/game_result.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:app/shared/repository/quiz_cards_repository.dart';
import 'package:flutter/material.dart';

import 'quiz_game_event.dart';
import 'quiz_game_state.dart';
import 'package:bloc/bloc.dart';

class QuizGameBloc extends Bloc<QuizGameEvent, QuizGameState>{

  final IntroShowedRepository introShowedRepository;
  final QuizCardsRepository quizCardsRepository;
  final QuizGameConfiguration configuration;

  QuizGameBloc({@required this.introShowedRepository, @required this.quizCardsRepository,
                @required this.configuration});

  QuizGameState get initialState => introShowedRepository.isShowed(
    configuration.screenType
  ) ? GameLoading() : ShowIntro();

  @override
  Stream<QuizGameState> mapEventToState(QuizGameEvent event) async* {
    if (event is IntroIsOver){
      yield* _mapIntroOver(event);
    } else if (event is QuizCardsLoaded){
      yield* _mapCardsLoaded(event);
    } else if (event is UserIsReady){
      yield* _mapUserReady(event);
    } else if (event is UserAnswered){
      yield* _mapUserAnswered(event);
    } else if (event is QuestionTimeout){
      yield* _mapQuestionTimeout(event);
    }
  }

  Stream<QuizGameState> _mapAnswer(bool value)async*{
    var game = state as GameActive;
    var answers = game.answers;
    answers.add(value);
    var current = game.currentCard + 1;

    if (answers.length == game.cards.length){
      yield GameOver(
        gameResult: GameResult(
          answers: answers,
          quizCards: game.cards
        )
      );
    } else {
      yield game.copyWith(
        answers: answers,
        currentCard: current
      );
    }
  }

  Stream<QuizGameState> _mapQuestionTimeout(QuestionTimeout event)async*{
    yield* _mapAnswer(false);
  }

  Stream<QuizGameState> _mapUserAnswered(UserAnswered event)async*{
    var game = state as GameActive;
    var value = game.cards[game.currentCard].answerIndex == event.answerIndex;
    yield* _mapAnswer(value);
  }

  Stream<QuizGameState> _mapUserReady(UserIsReady event)async*{
    var game =  GameActive(
      cards: (state as WaitForBegin).cards,
    );
    yield game;
  }

  Stream<QuizGameState> _mapCardsLoaded(QuizCardsLoaded event)async*{
    yield WaitForBegin(
      cards: event.cards
    );
  }

  Stream<QuizGameState> _mapIntroOver(IntroIsOver event)async*{
    yield GameLoading();
    quizCardsRepository.getCards().then((cards){
      add(QuizCardsLoaded(
        cards: cards
      ));
    });
  }

}
			