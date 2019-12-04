import 'package:flutter/material.dart';

class Card{
  final String imageUrl;
  final String word;
  final List<String> translates;
  final String description;

  const Card({this.imageUrl, this.word, this.translates, this.description});
}