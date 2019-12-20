import 'package:app/shared/entity/quiz_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WhatIsGameEvent extends Equatable {
  const WhatIsGameEvent();

  @override
  List<Object> get props => [];

}
			
class IntroIsOver extends WhatIsGameEvent{}

class QuizCardsLoaded extends WhatIsGameEvent{
  final List<QuizCard> cards;

  const QuizCardsLoaded({@required this.cards});

  @override
  List<Object> get props => [cards];
}

class UserIsReady extends WhatIsGameEvent{}