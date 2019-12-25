import 'package:app/shared/entity/game_result.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class QuizGameState extends Equatable {
  const QuizGameState();

  @override
  List<Object> get props => [];

}

class ShowIntro extends QuizGameState{}

class GameLoading extends QuizGameState{}

class WaitForBegin extends QuizGameState{
  final List<QuizCard> cards;

  const WaitForBegin({@required this.cards});
}

class GameActive extends QuizGameState{
  final List<QuizCard> cards;
  List<bool> answers;
  final int currentCard;

  GameActive({@required this.cards, this.currentCard = 0,
              this.answers}){
    this.answers = this.answers ?? List<bool>();
  }

  GameActive copyWith({List<QuizCard> cards, List<bool> answers, int currentCard}){
    return GameActive(
      cards: cards ?? this.cards,
      answers: answers ?? this.answers,
      currentCard: currentCard ?? this.currentCard
    );
  }

  @override
  List<Object> get props => [cards, answers, currentCard];
}


class GameOver extends QuizGameState{
  final GameResult gameResult;

  const GameOver({@required this.gameResult});
}