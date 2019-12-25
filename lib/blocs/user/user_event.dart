import 'package:app/shared/entity/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];

}

class LoginTrial extends UserEvent{
  final String login;
  final String password;

  const LoginTrial({@required this.login, @required this.password});

  @override
  List<Object> get props => [login, password];
}

class Unlogin extends UserEvent{}

class GotUser extends UserEvent{
  final User user;

  const GotUser({@required this.user});
}