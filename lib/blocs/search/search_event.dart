import 'package:app/blocs/search/search_state.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];

}

class SearchTextEdited extends SearchEvent{
  final String text;

  const SearchTextEdited({@required this.text});

  @override
  List<Object> get props => [text];
}

class SearchTextEditingDone extends SearchEvent{
  final String text;

  const SearchTextEditingDone({@required this.text});

  @override
  List<Object> get props => [text];
}

class SearchLanguageChanged extends SearchEvent{}

class SearchTypeChanged extends SearchEvent{
  final SearchType searchType;

  const SearchTypeChanged({@required this.searchType});
}

			