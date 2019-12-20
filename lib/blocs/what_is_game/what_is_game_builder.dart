import 'package:app/blocs/home/home_bloc.dart';
import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:app/shared/repository/quiz_cards_repository.dart';

import 'what_is_game_screen.dart';
import 'what_is_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhatIsGameBuilder extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WhatIsGameBuilderState();

}

class _WhatIsGameBuilderState extends State<WhatIsGameBuilder>{

  WhatIsGameBloc whatIsGameBloc;

  @override
  void initState() {
    AppDependencyRepository.
        repositoriesContainer.register<QuizCardsRepository>((c) => QuizCardsRepository());
    whatIsGameBloc = WhatIsGameBloc(
      introShowedRepository: AppDependencyRepository.repositoriesContainer.get<IntroShowedRepository>(),
      quizCardsRepository: AppDependencyRepository.repositoriesContainer.get<QuizCardsRepository>()
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    whatIsGameBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WhatIsGameBloc>.value(
      value: whatIsGameBloc,
      child: WhatIsGameScreen(
        whatIsGameBloc: whatIsGameBloc,
      ),
    );
  }

}
			