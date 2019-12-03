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
}
			
class SearchLoading extends SearchState{}

class SearchDone extends SearchState{
  final String text;

  SearchDone({@required this.text});
}