import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class GameOverviewEvent extends Equatable {
  const GameOverviewEvent();

  @override
  List<Object> get props => [];

}

class WordAddedStateChanged extends GameOverviewEvent{
  final int index;

  const WordAddedStateChanged({@required this.index});
}
			