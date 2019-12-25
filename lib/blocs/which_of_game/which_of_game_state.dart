import 'package:app/shared/entity/game_result.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WhichOfGameState extends Equatable {
  const WhichOfGameState();

  @override
  List<Object> get props => [];

}

class ShowIntro extends WhichOfGameState{}

class GameLoading extends WhichOfGameState{}

class WaitForBegin extends WhichOfGameState{
  final List<QuizCard> cards;

  const WaitForBegin({@required this.cards});
}

class GameActive extends WhichOfGameState{
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


class GameOver extends WhichOfGameState{
  final GameResult gameResult;

  const GameOver({@required this.gameResult});
}