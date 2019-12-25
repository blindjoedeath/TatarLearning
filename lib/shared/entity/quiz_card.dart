import 'package:app/shared/entity/word_card.dart';
import 'package:flutter/material.dart';

class QuizCard{
  final List<WordCard> variants;
  final int answerIndex;

  const QuizCard({@required this.variants, @required this.answerIndex})
    : assert(variants != null), assert(answerIndex != null);
}