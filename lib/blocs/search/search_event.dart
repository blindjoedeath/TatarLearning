import 'package:app/blocs/search/search_state.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];

}

class SearchBlocInited extends SearchEvent{}

class SearchTextEdited extends SearchEvent{
  final String text;
  final bool isLastCharacter;

  const SearchTextEdited({@required this.text, this.isLastCharacter = false});

  @override
  List<Object> get props => [text];
}

class SearchTextEditingDebounced extends SearchEvent{
  final String text;

  const SearchTextEditingDebounced({@required this.text});

  @override
  List<Object> get props => [text];
}

class SearchLanguageChanged extends SearchEvent{}

class SearchTypeChanged extends SearchEvent{
  final SearchType searchType;

  const SearchTypeChanged({@required this.searchType});
}

class SearchRequestCreated extends SearchEvent{
  const SearchRequestCreated();
}	

class SearchRequestCanceled extends SearchEvent{
  const SearchRequestCanceled();
}	

class SearchRequestDone extends SearchEvent{
  final List<WordCard> cards;

  const SearchRequestDone({@required this.cards});
}			

class UserExploredSearchResult extends SearchEvent{
  final String query;

  const UserExploredSearchResult({@required this.query});
}

class ReturnedFromDetailView extends SearchEvent{
}