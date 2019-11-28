import 'package:app/shared/repository/welcomed_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState>{

  final WelcomedRepository welcomedRepository;

  AppBloc({@required this.welcomedRepository}) : assert(welcomedRepository != null);

  AppState get initialState => welcomedRepository.isWelcomed ? LoadApp() : WelcomeUser();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is WelcomedUser){
      welcomedRepository.isWelcomed = true;
      yield LoadApp();
    }
  }
}