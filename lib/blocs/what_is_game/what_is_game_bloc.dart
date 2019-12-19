import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:flutter/material.dart';

import 'what_is_game_event.dart';
import 'what_is_game_state.dart';
import 'package:bloc/bloc.dart';

class WhatIsGameBloc extends Bloc<WhatIsGameEvent, WhatIsGameState>{

  final IntroShowedRepository introShowedRepository;

  WhatIsGameBloc({@required this.introShowedRepository});

  WhatIsGameState get initialState => introShowedRepository.isShowed(
    Screen.WhatIsGame
  ) ? ShowGame() : ShowIntro();

  @override
  Stream<WhatIsGameState> mapEventToState(WhatIsGameEvent event) async* {
    if (event is IntroIsOver){
      yield ShowGame();
    }
  }

}
			