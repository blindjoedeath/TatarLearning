import 'dart:async';

import 'package:app/blocs/search/search_bloc.dart';
import 'package:app/blocs/search/search_event.dart';
import 'package:flutter/material.dart';

import 'tab_menu_event.dart';
import 'tab_menu_state.dart';
import 'package:bloc/bloc.dart';

class TabMenuBloc extends Bloc<TabMenuEvent, TabMenuState>{

  final SearchBloc searchBloc;
  Future<void> heroTransition;

  TabMenuBloc({@required this.searchBloc, this.heroTransition}){
    if (heroTransition != null){
      heroTransition.whenComplete((){
        add(HomeTabPressed());
      });
    }
  }

  TabMenuState get initialState => 
    heroTransition == null ? HomeTab() : WaitHeroTransition();

  @override
  Stream<TabMenuState> mapEventToState(TabMenuEvent event) async* {
    if(!searchBloc.isInited){
      await searchBloc.init();
    }
    if (event is HomeTabPressed){
      yield HomeTab();
    } else if (event is UserTabPressed){
      yield UserTab();
    }else if (event is SearchTabPressed){
      searchBloc.add(ReturnedToView());
      yield SearchTab();
    }
  }
}