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

class WaitForBegin extends WhatIsGameState{
  final List<QuizCard> cards;

  const WaitForBegin({@required this.cards});
}

class GameActive extends WhatIsGameState{
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


class GameOver extends WhatIsGameState{}