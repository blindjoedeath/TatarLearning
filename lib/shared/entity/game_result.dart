import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:flutter/material.dart';

class GameResult{
  final List<QuizCard> quizCards;
  final List<bool> answers;

  WordCard getCard(int index){
    var answer = quizCards[index].answerIndex;
    var card = quizCards[index].variants[answer];
    return card;
  }

  const GameResult({@required this.quizCards, @required this.answers});
}