import 'package:app/shared/entity/game_result.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:app/shared/repository/quiz_cards_repository.dart';
import 'package:flutter/material.dart';

import 'which_of_game_event.dart';
import 'which_of_game_state.dart';
import 'package:bloc/bloc.dart';

class WhichOfGameBloc extends Bloc<WhichOfGameEvent, WhichOfGameState>{

  final IntroShowedRepository introShowedRepository;
  final QuizCardsRepository quizCardsRepository;

  WhichOfGameBloc({@required this.introShowedRepository, @required this.quizCardsRepository});

  WhichOfGameState get initialState => introShowedRepository.isShowed(
    Screen.WhichOfGame
  ) ? GameLoading() : ShowIntro();

  @override
  Stream<WhichOfGameState> mapEventToState(WhichOfGameEvent event) async* {
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

  Stream<WhichOfGameState> _mapAnswer(bool value)async*{
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

  Stream<WhichOfGameState> _mapQuestionTimeout(QuestionTimeout event)async*{
    yield* _mapAnswer(false);
  }

  Stream<WhichOfGameState> _mapUserAnswered(UserAnswered event)async*{
    var game = state as GameActive;
    var value = game.cards[game.currentCard].answerIndex == event.answerIndex;
    yield* _mapAnswer(value);
  }

  Stream<WhichOfGameState> _mapUserReady(UserIsReady event)async*{
    var game =  GameActive(
      cards: (state as WaitForBegin).cards,
    );
    yield game;
  }

  Stream<WhichOfGameState> _mapCardsLoaded(QuizCardsLoaded event)async*{
    yield WaitForBegin(
      cards: event.cards
    );
  }

  Stream<WhichOfGameState> _mapIntroOver(IntroIsOver event)async*{
    yield GameLoading();
    quizCardsRepository.getCards().then((cards){
      add(QuizCardsLoaded(
        cards: cards
      ));
    });
  }

}
			