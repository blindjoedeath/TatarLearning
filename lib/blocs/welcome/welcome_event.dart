import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WelcomeEvent extends Equatable {
  const WelcomeEvent();
  @override get props => [];
}

class UserInteracted extends WelcomeEvent{}