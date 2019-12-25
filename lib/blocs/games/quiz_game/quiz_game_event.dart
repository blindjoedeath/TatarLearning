import 'package:app/shared/entity/quiz_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class QuizGameEvent extends Equatable {
  const QuizGameEvent();

  @override
  List<Object> get props => [];

}
			
class IntroIsOver extends QuizGameEvent{}

class QuizCardsLoaded extends QuizGameEvent{
  final List<QuizCard> cards;

  const QuizCardsLoaded({@required this.cards});

  @override
  List<Object> get props => [cards];
}

class UserIsReady extends QuizGameEvent{}

class UserAnswered extends QuizGameEvent{
  final int answerIndex;

  const UserAnswered({@required this.answerIndex});
}

class QuestionTimeout extends QuizGameEvent{}