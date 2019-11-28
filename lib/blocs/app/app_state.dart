import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState();
  @override get props => [];
}

class WelcomeUser extends AppState{}

class LoadApp extends AppState{}