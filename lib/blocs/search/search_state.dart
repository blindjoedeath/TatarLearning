import 'package:app/shared/entity/search_queries.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/entity/language.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum SearchType{Global, Local}

class SearchState extends Equatable {

  final Language searchLanguage;
  final SearchType searchType;
  final String searchText;
  final bool isLoading;
  bool get isEmpty => !isLoading && globalCards == null && searchType == SearchType.Global;
  bool get isSearchDone => !isEmpty && !isLoading;
  final List<WordCard> globalCards;
  final List<WordCard> localCards;
  final SearchQueries searchHistory;

  const SearchState({this.searchLanguage = Language.Russian, this.searchType = SearchType.Local,
                    this.searchText, this.isLoading = false, this.globalCards, this.localCards,
                    this.searchHistory});

  @override
  List<Object> get props => [searchLanguage, searchType, searchText,
                             isLoading, globalCards, localCards, 
                             searchHistory];

  SearchState copyWith({Language searchLangage, SearchType searchType, String searchText,
                        bool isLoading, List<WordCard> globalCards, List<WordCard> localCards,
                        SearchQueries searchHistory}){
    return SearchState(
      searchLanguage: searchLangage ?? this.searchLanguage,
      searchType: searchType ?? this.searchType,
      searchText: searchText ?? this.searchText,
      isLoading: isLoading ?? this.isLoading,
      globalCards: globalCards ?? this.globalCards,
      localCards: localCards ?? this.localCards,
      searchHistory: searchHistory ?? this.searchHistory
    );
  }

  SearchState noGlobalCards(){
    return SearchState(
      searchLanguage: this.searchLanguage,
      searchType: this.searchType,
      searchText: this.searchText,
      isLoading: this.isLoading,
      searchHistory: this.searchHistory,
      localCards: this.localCards
    );
  }
}

