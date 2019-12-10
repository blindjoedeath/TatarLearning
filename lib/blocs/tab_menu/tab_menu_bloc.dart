import 'dart:async';

import 'package:app/blocs/search/search_bloc.dart';
import 'package:flutter/material.dart';

import 'tab_menu_event.dart';
import 'tab_menu_state.dart';
import 'package:bloc/bloc.dart';

class TabMenuBloc extends Bloc<TabMenuEvent, TabMenuState>{

  final SearchBloc searchBloc;

  TabMenuBloc({@required this.searchBloc});

  TabMenuState get initialState => HomeTab();
  @override
  Stream<TabMenuState> mapEventToState(TabMenuEvent event) async* {
    if(!searchBloc.isInited){
      await searchBloc.init();
    }
    if (event is HomeTabPressed){
      yield HomeTab();
    } else if (event is SearchTabPressed){
      yield SearchTab();
    }
  }
}