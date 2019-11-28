import 'package:equatable/equatable.dart';

abstract class TabMenuEvent extends Equatable {
  const TabMenuEvent();

    @override get props => [];
}

class HomeTabPressed extends TabMenuEvent{}

class SearchTabPressed extends TabMenuEvent{}