import 'package:app/blocs/home/home_bloc.dart';
import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:app/shared/repository/quiz_cards_repository.dart';

import 'which_of_game_screen.dart';
import 'which_of_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhichOfGameBuilder extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WhichOfGameBuilderState();

}

class _WhichOfGameBuilderState extends State<WhichOfGameBuilder>{

  WhichOfGameBloc whichOfGameBloc;

  @override
  void initState() {
    AppDependencyRepository.
        repositoriesContainer.register<QuizCardsRepository>((c) => QuizCardsRepository());
    whichOfGameBloc = WhichOfGameBloc(
      introShowedRepository: AppDependencyRepository.repositoriesContainer.get<IntroShowedRepository>(),
      quizCardsRepository: AppDependencyRepository.repositoriesContainer.get<QuizCardsRepository>()
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    whichOfGameBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WhichOfGameBloc>.value(
      value: whichOfGameBloc,
      child: WhichOfGameScreen(
        whichOfGameBloc: whichOfGameBloc,
      ),
    );
  }

}
			