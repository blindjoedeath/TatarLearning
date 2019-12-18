import 'what_is_game_event.dart';
import 'what_is_game_state.dart';
import 'package:bloc/bloc.dart';

class WhatIsGameBloc extends Bloc<WhatIsGameEvent, WhatIsGameState>{

  WhatIsGameState get initialState => ShowIntro();

  @override
  Stream<WhatIsGameState> mapEventToState(WhatIsGameEvent event) async* {
    if (event is IntroIsOver){
      yield ShowGame();
    }
  }

}
			