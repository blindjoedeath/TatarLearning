import 'package:app/shared/entity/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];

}

class Loading extends UserState{}

class LoadingForLogin extends UserState{}

class Login extends UserState{} 

class Authenticated extends UserState{
  final User user;

  const Authenticated({@required this.user});
}