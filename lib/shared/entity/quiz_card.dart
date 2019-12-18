import 'package:flutter/material.dart';

class QuizCard{
  final String imageUrl;
  final List<String> variants;
  final int answerIndex;

  const QuizCard({@required this.imageUrl, @required this.variants, @required this.answerIndex})
    : assert(imageUrl != null), assert(variants != null), assert(answerIndex != null);
}