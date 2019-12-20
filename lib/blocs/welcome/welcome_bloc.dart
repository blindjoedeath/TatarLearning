import 'package:app/blocs/app/app_event.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'welcome_event.dart';
import 'welcome_state.dart';
import '../app/app_bloc.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState>{

  @override
  WelcomeState get initialState => WaitForUserIntraction();
  
  @override
  Stream<WelcomeState> mapEventToState(WelcomeEvent event) {
  }
}