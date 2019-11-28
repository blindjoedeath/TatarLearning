import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
  @override get props => [];
}

class WelcomedUser extends AppEvent{}