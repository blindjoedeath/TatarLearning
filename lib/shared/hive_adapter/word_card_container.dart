import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:app/shared/entity/word_card.dart';

@HiveType()
class WordCardContainer{
  @HiveField(0)
  List<WordCard> cards = List<WordCard>();
}