import 'dart:async';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/hive_adapter/word_card_container.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';


const String _kLocalCardsBox = "localCardsBox";
const String _kListKey = "cardListKey";

class WordCardDbProvider {

  bool get isInited => Hive.isBoxOpen(_kLocalCardsBox);

  Box<WordCardContainer> get _box => Hive.box<WordCardContainer>(_kLocalCardsBox);

  List<WordCard> _cards(){
    var container = _box.get(_kListKey, defaultValue: WordCardContainer());
    return container.cards;
  }

  Future<void> init()async{
    return await Hive.openBox<WordCardContainer>(_kLocalCardsBox);
  }

  bool contains(WordCard card){
    return _cards().contains(card);
  }

  Future<void> _saveCards(List<WordCard> cards)async{
    var container = WordCardContainer();
    container.cards = cards;
    return await _box.put(_kListKey, container);
  }

  Future<void> delete(WordCard card)async{
    var cards = _cards();
    cards.remove(card);
    return await _saveCards(cards);
  }

  Future<List<WordCard>> fetchCards(String word)async{
    return Future<List<WordCard>>.microtask((){
      var lowerSearch = word.toLowerCase();
      return _cards().where((card) => card.word.toLowerCase().startsWith(lowerSearch)).toList();
    });
  }

  Future<void> save(WordCard card)async{
    var cards = _cards();
    cards.add(card);
    return await _saveCards(cards);
  }

  Future<void> dispose()async{
    if (isInited){
      return await _box.close();
    }
  }
}