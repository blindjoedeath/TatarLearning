import 'package:app/blocs/games/quiz_game/quiz_game.dart';
import 'package:app/blocs/games/quiz_game/quiz_game_configuration.dart';
import 'package:app/blocs/games/quiz_game/quiz_game_intro.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/widget/bounce_button.dart';

import 'quiz_game_builder.dart';
import 'quiz_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'quiz_game_state.dart';
import 'quiz_game_event.dart';


class QuizGameScreen extends StatelessWidget {

  final QuizGameBloc quizGameBloc;
  final QuizGameConfiguration configuration;

  const QuizGameScreen({@required this.quizGameBloc, @required this.configuration});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizGameBloc, QuizGameState>(
      builder: (context, state){
        if (state is ShowIntro){
          return QuizGameIntro(
            intros: configuration.intros,
            quizGameBloc: quizGameBloc,
          );
        } else {
          return QuizGame(
            mainColor: configuration.mainColor,
            secondColor: configuration.secondColor,
            cardBuilder: configuration.cardBuilder,
            quizGameBloc: quizGameBloc,
          );
        }
      }
    );
  }

}