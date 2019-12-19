import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:flutter/material.dart';

import 'home_event.dart';
import 'home_state.dart';
import 'package:bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{

  HomeState get initialState => HomeIsNotInited();

  final IntroShowedRepository introShowedRepository;

  HomeBloc({@required this.introShowedRepository});

  bool get isInited => introShowedRepository.isInited;

  Future init()async{
    await introShowedRepository.init();
    
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeIsNotInited){
      await init();
    } else if (event is HomeBlocInited){
      yield HomeDefaultState();
    } else if (event is WhatIsGamePressed){
      yield ShowWhatIsGame();
    } else if (event is ReturnedFromGame){
      yield HomeDefaultState();
    }
  }

}
			