import 'dart:async';

import 'tab_menu_event.dart';
import 'tab_menu_state.dart';
import 'package:bloc/bloc.dart';

class TabMenuBloc extends Bloc<TabMenuEvent, TabMenuState>{

  TabMenuState get initialState => HomeTab();
  @override
  Stream<TabMenuState> mapEventToState(TabMenuEvent event) async* {
    if (event is HomeTabPressed){
      yield HomeTab();
    } else if (event is SearchTabPressed){
      yield SearchTab();
    }
  }
}