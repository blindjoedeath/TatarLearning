import 'dart:async';
import 'package:async/async.dart';
import 'package:app/shared/entity/language.dart';
import 'package:app/shared/repository/card_repository.dart';
import 'package:flutter/material.dart';

import 'search_event.dart';
import 'search_state.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState>{

  final CardSearchRepository cardSearchRepository;

  final PublishSubject<SearchTextEdited> _debounceSubject = PublishSubject<SearchTextEdited>();

  // used inside debouce states stream
  CancelableOperation _cardsCancelableOperation;
  
  Stream<SearchState> get _debounceStates{
    return _debounceSubject.stream
      .where((event) => event is SearchTextEdited)
      .cast<SearchTextEdited>()
      .doOnData((data) => this._cardsCancelableOperation?.cancel())
      .debounceTime(Duration(milliseconds: 250))
      .distinct()
      .switchMap((e){
        var event = SearchTextEditingDone(text: e.text);
        return mapEventToState(event);
      }).share();
  }

  SearchBloc({@required this.cardSearchRepository}) : assert(cardSearchRepository != null);

  @override
  close(){
    _debounceSubject?.close();
    _cardsCancelableOperation?.cancel();
    super.close();
  }

  SearchState get initialState => SearchState(
    searchLanguage: Language.Russian,
    searchType: SearchType.Local
  );

  @override
  Stream<SearchState> transformEvents(Stream<SearchEvent> events, Stream<SearchState> Function(SearchEvent event) next){
    var nonDebounceStates = super.transformEvents(events, next) as Observable<SearchState>;
    return nonDebounceStates.mergeWith([_debounceStates]);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchTextEdited && event.text.isNotEmpty){
      if (state.searchType == SearchType.Local){
        yield* _mapTextEdited(event.text);
      } else {
        _debounceSubject.add(event);
      }
    } else if(event is SearchTextEditingDone && event.text.isNotEmpty){
      yield* _mapTextEdited(event.text);
    } else if (event is SearchLanguageChanged){
      yield* _mapLanguageChanged(event);
    } else if(event is SearchTypeChanged){
      yield* _mapSearchTypeChanged(event);
    } else {
      yield state.copyWith();
    }
  }

  Stream<SearchState> _mapLanguageChanged(SearchLanguageChanged event) async* {
    var lang = state.searchLanguage == Language.Russian ? Language.Tatar : Language.Russian;
    yield state.copyWith(searchLangage: lang);
  }

  Stream<SearchState> _mapSearchTypeChanged(SearchTypeChanged event) async* {
    yield state.copyWith(searchType: event.searchType);
  }

  Stream<SearchState> _mapTextEdited(String text) async* {
    yield state.searchLoading();
    final future = cardSearchRepository.find(text, state.searchType);
    _cardsCancelableOperation = CancelableOperation.fromFuture(future);
    final cards = await _cardsCancelableOperation.value;
    yield state.searchDone(cards);
  }
}
			