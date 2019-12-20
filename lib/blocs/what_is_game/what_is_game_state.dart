import 'package:app/shared/entity/quiz_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WhatIsGameState extends Equatable {
  const WhatIsGameState();

  @override
  List<Object> get props => [];

}

class ShowIntro extends WhatIsGameState{}

class GameLoading extends WhatIsGameState{}

class GameLoaded extends WhatIsGameState{
  final List<QuizCard> cards;

  const GameLoaded({@required this.cards});

  @override
  List<Object> get props => [cards];
}