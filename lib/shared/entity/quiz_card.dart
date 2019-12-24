import 'package:app/shared/entity/word_card.dart';
import 'package:flutter/material.dart';

class QuizCard{
  final String imageUrl;
  final List<WordCard> variants;
  final int answerIndex;

  const QuizCard({@required this.imageUrl, @required this.variants, @required this.answerIndex})
    : assert(imageUrl != null), assert(variants != null), assert(answerIndex != null);
}