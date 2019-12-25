import 'package:app/shared/entity/quiz_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WhichOfGameEvent extends Equatable {
  const WhichOfGameEvent();

  @override
  List<Object> get props => [];

}
			
class IntroIsOver extends WhichOfGameEvent{}

class QuizCardsLoaded extends WhichOfGameEvent{
  final List<QuizCard> cards;

  const QuizCardsLoaded({@required this.cards});

  @override
  List<Object> get props => [cards];
}

class UserIsReady extends WhichOfGameEvent{}

class UserAnswered extends WhichOfGameEvent{
  final int answerIndex;

  const UserAnswered({@required this.answerIndex});
}

class QuestionTimeout extends WhichOfGameEvent{}