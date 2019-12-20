import 'package:app/blocs/tab_menu/tab_menu_bloc.dart';
import 'package:app/blocs/tab_menu/tab_menu_state.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:flutter/material.dart';

import 'home_event.dart';
import 'home_state.dart';
import 'package:bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{

  final IntroShowedRepository introShowedRepository;

  final TabMenuBloc tabMenuBloc;

  HomeBloc({@required this.introShowedRepository, @required this.tabMenuBloc}){
    init();
    tabMenuBloc.listen((s){
      if (s is HomeTab){
        add(HeroTransitionDone());
      }
    });
  }

  HomeState get initialState => HomeIsNotInited();

  bool get isInited => introShowedRepository.isInited;

  Future init()async{
    await introShowedRepository.init().whenComplete((){
      add(HomeBlocInited());
    });
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeBlocInited || event is HeroTransitionDone){
      yield HomeDefaultState(
        withHeros: tabMenuBloc.state is! WaitHeroTransition
      );
    } else if (event is WhatIsGamePressed){
      yield ShowWhatIsGame();
    } else if (event is Showed){
      yield HomeDefaultState();
    }


    if (state is HomeIsNotInited){
      await init();
    } 
  }

}
			