import 'package:equatable/equatable.dart';

abstract class WelcomeState extends Equatable{
  const WelcomeState();

  @override get props => [];
}

class WaitForUserIntraction extends WelcomeState{}