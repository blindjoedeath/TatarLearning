import 'package:equatable/equatable.dart';

abstract class TabMenuState extends Equatable{
  const TabMenuState();

  @override get props => [];
}

class HomeTab extends TabMenuState{}

class SearchTab extends TabMenuState{}