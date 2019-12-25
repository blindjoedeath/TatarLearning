import 'package:app/shared/entity/word_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DictionaryState extends Equatable {
  const DictionaryState();

  @override
  List<Object> get props => [];

}

class Loading extends DictionaryState{}

class CardsLoaded extends DictionaryState{
  final List<WordCard> cards;

  const CardsLoaded({@required this.cards});

  @override
  List<Object> get props => [cards];
}
			