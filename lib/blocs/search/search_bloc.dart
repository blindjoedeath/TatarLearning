import 'dart:async';
import 'package:async/async.dart';
import 'package:app/shared/entity/language.dart';
import 'package:app/shared/repository/word_card_repository.dart';
import 'package:flutter/material.dart';

import 'search_event.dart';
import 'search_state.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState>{

  final WordCardSearchRepository wordCardSearchRepository;

  final PublishSubject<SearchTextEdited> _debounceSubject = PublishSubject<SearchTextEdited>();

  StreamSubscription _cardsLoadingSubscription;
  
  Stream<SearchState> get _debounceStates{
    return _debounceSubject.stream
      .where((event) => event is SearchTextEdited)
      .cast<SearchTextEdited>()
      .debounceTime(Duration(milliseconds: 250))
      .distinct()
      .switchMap((e){
        var event = SearchTextEditingDone(text: e.text);
        return mapEventToState(event);
      }).share();
  }

  SearchBloc({@required this.wordCardSearchRepository}) : assert(wordCardSearchRepository != null);

  @override
  close(){
    _debounceSubject?.close();
    _cardsLoadingSubscription?.cancel();
    super.close();
  }

  SearchState get initialState => SearchState(
    searchLanguage: Language.Russian,
    searchType: SearchType.Local,
    searchText: ""
  );

  @override
  Stream<SearchState> transformEvents(Stream<SearchEvent> events, Stream<SearchState> Function(SearchEvent event) next){
    var nonDebounceStates = super.transformEvents(events, next) as Observable<SearchState>;
    return nonDebounceStates.mergeWith([_debounceStates]);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    print(state.isLoading);
    if (event is SearchTextEdited){
      _cardsLoadingSubscription?.cancel();
      if (state.searchType == SearchType.Local){
        yield* _mapTextEdited(event.text);
      } else {
        _debounceSubject.add(event);
      }
    } else if(event is SearchTextEditingDone){
      yield* _mapTextEdited(event.text);
    } else if (event is SearchLanguageChanged){
      yield* _mapLanguageChanged(event);
    } else if(event is SearchTypeChanged){
      yield* _mapSearchTypeChanged(event);
    } else if (event is SearchRequestDone){
      yield* _mapSearchRequestDone(event);
    } else {
      yield state.copyWith();
    }
  }

  Stream<SearchState> _mapLanguageChanged(SearchLanguageChanged event) async* {
    var lang = state.searchLanguage == Language.Russian ? Language.Tatar : Language.Russian;
    yield state.copyWith(searchLangage: lang);
  }

  Stream<SearchState> _mapSearchTypeChanged(SearchTypeChanged event) async* {
    var newState = state.copyWith(searchType: event.searchType);
    yield newState;
    if (state.searchText != null && state.searchText.isNotEmpty){
      if ((event.searchType == SearchType.Global && state.globalCards == null) ||
          (event.searchType == SearchType.Local && state.localCards == null)){
          yield newState.copyWith(isLoading: true);
         _mapAsyncRequest(state.searchText, event.searchType);
      }
    }
  }

  void _mapAsyncRequest(String text, SearchType searchType){
    _cardsLoadingSubscription = wordCardSearchRepository
      .find(text, searchType)
      .asStream()
      .listen((data){
        this.add(SearchRequestDone(cards: data));
      });
  }

  Stream<SearchState> _mapTextEdited(String text) async* {
    if (text.isEmpty && state.isLoading){
      yield state.copyWith(isLoading: false);
      return;
    }

    print(state.isLoading);
    if (state.searchText == text && !state.isLoading){
      return;
    }

    var newState = state.noCards().copyWith(searchText: text);
    yield newState;

    if (text.isNotEmpty){
      yield newState.copyWith(isLoading: true);
      _mapAsyncRequest(text, state.searchType);
    }
  }

  Stream<SearchState> _mapSearchRequestDone(SearchRequestDone event) async* {
    if (state.searchType == SearchType.Global){
      yield state.copyWith(globalCards: event.cards, isLoading: false);
    } else {
      yield state.copyWith(localCards: event.cards, isLoading: false);
    }
  }
}
			