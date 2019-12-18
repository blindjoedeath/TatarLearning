import 'package:app/blocs/what_is_game/what_is_game_intro.dart';

import 'what_is_game_builder.dart';
import 'what_is_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'what_is_game_state.dart';
import 'what_is_game_event.dart';


class WhatIsGameScreen extends StatelessWidget {

  final WhatIsGameBloc whatIsGameBloc;

  const WhatIsGameScreen({@required this.whatIsGameBloc});


  Widget _buildBody(WhatIsGameState state){
    if (state is ShowIntro){
      return WhatIsGameIntro(
        whatIsGameBloc: whatIsGameBloc,
      );
    }
    return Column(
      children: <Widget>[
        Center(
          child: Text("text")
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhatIsGameBloc, WhatIsGameState>(
        builder: (context, state){
          if (state is! ShowIntro){
            return Scaffold(
              appBar: AppBar(),
            );
          }
          return _buildBody(state);
        }
    );
  }

}
			