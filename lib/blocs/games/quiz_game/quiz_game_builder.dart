import 'package:app/blocs/home/home_bloc.dart';
import 'package:app/blocs/games/quiz_game/quiz_game_configuration.dart';
import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:app/shared/repository/quiz_cards_repository.dart';

import 'quiz_game_screen.dart';
import 'quiz_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizGameBuilder extends StatefulWidget {

  final QuizGameConfiguration configuration;

  const QuizGameBuilder({@required this.configuration});

  @override
  State<StatefulWidget> createState() => _QuizGameBuilderState();

}

class _QuizGameBuilderState extends State<QuizGameBuilder>{

  QuizGameBloc quizGameBloc;

  @override
  void initState() {
    AppDependencyRepository.
        repositoriesContainer.register<QuizCardsRepository>((c) => QuizCardsRepository());
    quizGameBloc = QuizGameBloc(
      configuration: widget.configuration,
      introShowedRepository: AppDependencyRepository.repositoriesContainer.get<IntroShowedRepository>(),
      quizCardsRepository: AppDependencyRepository.repositoriesContainer.get<QuizCardsRepository>()
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    quizGameBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizGameBloc>.value(
      value: quizGameBloc,
      child: QuizGameScreen(
        configuration: widget.configuration,
        quizGameBloc: quizGameBloc,
      ),
    );
  }

}
			