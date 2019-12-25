
import 'package:app/blocs/games/quiz_game/quiz_game_bloc.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:flutter/material.dart';

class IntroPage{
  final Color color;
  final String title;
  final String body;
  final String imageUrl;

  const IntroPage({this.color = Colors.green, @required this.title, @required this.body, this.imageUrl});
}

class QuizGameConfiguration{
  final Color mainColor;
  final Color secondColor;
  final List<IntroPage> intros;
  final Screen screenType;
  final Widget Function(QuizCard, void Function(int)) cardBuilder;

  const QuizGameConfiguration({@required this.intros,
                               @required this.screenType,
                              @required this.cardBuilder,
                              this.mainColor = Colors.green,
                              this.secondColor = Colors.teal});
}