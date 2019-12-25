import 'package:app/shared/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'user_event.dart';
import 'user_state.dart';
import 'package:bloc/bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState>{

  final UserRepository userRepository;

  UserBloc({@required this.userRepository}){
    if (userRepository.isAuthorized){
      userRepository.get().then((user){
        add(GotUser(
          user: user
        ));
      });
    } else {
      add(Unlogin());
    }
  }

  UserState get initialState => Loading();

  @override
  void close() {
    super.close();
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GotUser){
      yield* _mapGotUser(event);
    } else if (event is LoginTrial){
      yield* _mapLoginTrial(event);
    } else if (event is Unlogin){
      yield* _mapUnlogin(event);
    }
  }


  Stream<UserState> _mapUnlogin(Unlogin event) async* {
    yield Login();
  }

  Stream<UserState> _mapLoginTrial(LoginTrial event) async* {
    yield LoadingForLogin();
    var user = await userRepository.authorize(event.login, event.password);
    yield Authenticated(
      user:user
    );
  }


  Stream<UserState> _mapGotUser(GotUser event) async* {
    yield Authenticated(
      user: event.user
    );
  }

}
			