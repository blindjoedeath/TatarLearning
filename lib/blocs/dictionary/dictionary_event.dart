import 'package:app/shared/entity/word_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DictionaryEvent extends Equatable {
  const DictionaryEvent();

  @override
  List<Object> get props => [];

}
			
class CardsLoadedEvent extends DictionaryEvent{
  final List<WordCard> cards;

  const CardsLoadedEvent({@required this.cards});

  @override
  List<Object> get props => [cards];
}

class CardRemoved extends DictionaryEvent{
  final int index;

  const CardRemoved({@required this.index});

  @override
  List<Object> get props => [index];
}