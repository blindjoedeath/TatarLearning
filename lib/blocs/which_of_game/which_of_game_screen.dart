import 'package:app/blocs/which_of_game/which_of_game.dart';
import 'package:app/blocs/which_of_game/which_of_game_intro.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/widget/bounce_button.dart';

import 'which_of_game_builder.dart';
import 'which_of_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'which_of_game_state.dart';
import 'which_of_game_event.dart';


class WhichOfGameScreen extends StatelessWidget {

  final WhichOfGameBloc whichOfGameBloc;

  const WhichOfGameScreen({@required this.whichOfGameBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhichOfGameBloc, WhichOfGameState>(
      builder: (context, state){
        if (state is ShowIntro){
          return WhichOfGameIntro(
            whichOfGameBloc: whichOfGameBloc,
          );
        } else {
          return WhichOfGame(
            whichOfGameBloc: whichOfGameBloc,
          );
        }
      }
    );
  }

}