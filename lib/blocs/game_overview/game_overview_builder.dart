import 'package:app/shared/entity/game_result.dart';
import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/word_card_repository.dart';

import 'game_overview_screen.dart';
import 'game_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameOverviewBuilder extends StatefulWidget {

  final GameResult gameResult;

  const GameOverviewBuilder({@required this.gameResult});

  @override
  State<StatefulWidget> createState() => _GameOverviewBuilderState();

}

class _GameOverviewBuilderState extends State<GameOverviewBuilder>{

  GameOverviewBloc gameOverviewBloc;

  @override
  void initState() {
    gameOverviewBloc = GameOverviewBloc(
      gameResult: widget.gameResult,
      wordCardRepository: AppDependencyRepository.repositoriesContainer.get<WordCardRepository>()
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    gameOverviewBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameOverviewBloc>.value(
      value: gameOverviewBloc,
      child: GameOverviewScreen(
        gameResult: widget.gameResult,
        gameOverviewBloc: gameOverviewBloc,
      ),
    );
  }

}
			