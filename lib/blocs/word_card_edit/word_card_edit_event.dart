import 'package:app/shared/entity/word_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WordCardEditEvent extends Equatable {
  const WordCardEditEvent();

  @override
  List<Object> get props => [];

}

class Save extends WordCardEditEvent{
  final String word;
  final String translate;
  final WordCard card;

  const Save({@required this.card, this.word, this.translate});
}			