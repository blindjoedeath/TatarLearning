import 'package:app/shared/entity/card.dart';
import 'package:app/shared/entity/language.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum SearchType{Global, Local}

class SearchState extends Equatable {

  const SearchState({this.searchLanguage = Language.Russian, this.searchType = SearchType.Local});

  final Language searchLanguage;
  final SearchType searchType;

  @override
  List<Object> get props => [searchLanguage, searchType];

  SearchState copyWith({Language searchLangage, SearchType searchType}){
    return SearchState(
      searchLanguage: searchLangage ?? this.searchLanguage,
      searchType: searchType ?? this.searchType
    );
  }

  SearchDone searchDone(List<Card> cards){
    return new SearchDone(
      cards: cards,
      language: this.searchLanguage,
      searchType: this.searchType
    );
  }

  SearchLoading searchLoading(){
    return new SearchLoading(
      language: this.searchLanguage,
      searchType: this.searchType
    );
  }
}
			
class SearchLoading extends SearchState{
    SearchLoading({Language language, SearchType searchType})
      : super(searchLanguage: language, searchType: searchType);
}

class SearchDone extends SearchState{
  final List<Card> cards;

  SearchDone({Language language, SearchType searchType, @required this.cards}) 
  : super(searchLanguage: language, searchType: searchType);
}