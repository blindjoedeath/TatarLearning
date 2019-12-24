import 'dart:async';
import 'package:app/shared/entity/search_queries.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/repository/app_state_repository.dart';
import 'package:app/shared/repository/search_history_repository.dart';
import 'package:async/async.dart';
import 'package:app/shared/entity/language.dart';
import 'package:app/shared/repository/word_card_repository.dart';
import 'package:flutter/material.dart';

import 'search_event.dart';
import 'search_state.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState>{

  final WordCardRepository wordCardRepository;

  final SearchHistoryRepository searchHistoryRepository;

  final PublishSubject<SearchTextEdited> _debounceSubject = PublishSubject<SearchTextEdited>();

  StreamSubscription _cardsLoadingSubscription;

  bool get isInited => searchHistoryRepository.isInited;

  Future init()async{
    await wordCardRepository.init();
    await searchHistoryRepository.init();
    add(SearchBlocInited());
  }
  
  Stream<SearchState> get _debounceStates{
    return _debounceSubject.stream
      .where((event) => event is SearchTextEdited)
      .cast<SearchTextEdited>()
      .debounce((event){
        var time = event.text.isNotEmpty ? 250 : 0;
        return TimerStream(true, Duration(milliseconds: time));
      })
      .switchMap((e){
        var event = SearchTextEditingDebounced(text: e.text);
        return mapEventToState(event);
      }).share();
  }

  SearchBloc({@required this.wordCardRepository,
              @required this.searchHistoryRepository})
    : assert(wordCardRepository != null),
      assert(searchHistoryRepository != null);

  @override
  close(){
    _debounceSubject?.close();
    _cardsLoadingSubscription?.cancel();
    super.close();
  }

  SearchState get initialState => SearchState(
    searchLanguage: Language.Russian,
    searchType: SearchType.Local,
    searchText: "",
  );

  @override
  Stream<SearchState> transformEvents(Stream<SearchEvent> events, Stream<SearchState> Function(SearchEvent event) next){
    var nonDebounceStates = super.transformEvents(events, next) as Observable<SearchState>;
    return nonDebounceStates.mergeWith([_debounceStates]);
  }
  
  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchBlocInited){
      yield state.copyWith(searchHistory: searchHistoryRepository.get(),
                           localCards: await wordCardRepository.find("", SearchType.Local));
    } else if (event is SearchTextEdited){
      if (state.searchType == SearchType.Local || event.isLastCharacter){
        yield* _mapTextEdited(event.text);
      } else {
        _debounceSubject.add(event);
      }
    } else if(event is SearchTextEditingDebounced){
      yield* _mapTextEdited(event.text);
    } else if (event is SearchLanguageChanged){
      yield* _mapLanguageChanged(event);
    } else if(event is SearchTypeChanged){
      yield* _mapSearchTypeChanged(event);
    } else if (event is SearchRequestCreated){
      yield state.copyWith(isLoading: true);
    } else if (event is SearchRequestCanceled){
      yield state.copyWith(isLoading: false);
    } else if (event is SearchRequestDone){
      yield* _mapSearchRequestDone(event);
    } else if (event is UserExploredSearchResult){
      yield* _mapUserExplored(event.query);
    } else if (event is ReturnedToView){
      yield* _mapReturnedFromView(event);
    }
  }

  Stream<SearchState> _mapReturnedFromView(SearchEvent query)async*{
    if (state.searchType == SearchType.Local){
      _createRequest(state.searchText, state.searchType);
    }
  }

  Stream<SearchState> _mapUserExplored(String query)async*{
    var history = state.searchHistory;
    history.add(query);
    await searchHistoryRepository.save(history);
    yield state.copyWith(searchHistory: history);
  }

  Stream<SearchState> _mapLanguageChanged(SearchLanguageChanged event) async* {
    var lang = state.searchLanguage == Language.Russian ? Language.Tatar : Language.Russian;
    yield state.copyWith(searchLangage: lang);
    if (state.searchText.isNotEmpty && state.searchType == SearchType.Global){
      _createRequest(state.searchText, state.searchType);
    }
  }

  Stream<SearchState> _mapSearchTypeChanged(SearchTypeChanged event) async* {
    yield state.copyWith(searchType: event.searchType);
    _cancelRequestIfActive();
    if (event.searchType == SearchType.Local || (event.searchType == SearchType.Global &&
        state.searchText.isNotEmpty && state.globalCards == null)){
      _createRequest(state.searchText, event.searchType);
    }
  }

  void _cancelRequestIfActive(){
    if (_cardsLoadingSubscription != null){
      _cardsLoadingSubscription?.cancel();
      _cardsLoadingSubscription = null;
      this.add(SearchRequestCanceled());
    }
  }

  void _createRequest(String text, SearchType searchType){
    _cancelRequestIfActive();
    _cardsLoadingSubscription = 
      wordCardRepository
      .find(text, searchType)
      .asStream().listen((cards){
        this.add(SearchRequestDone(
          cards: cards
        ));
      });
    this.add(SearchRequestCreated());
  }

  Stream<SearchState> _mapTextEdited(String text) async* {

    if (state.searchText == text && !state.isLoading){
      return;
    }

    yield state.noGlobalCards().copyWith(searchText: text);

    if (text.isEmpty && state.isLoading){
      _cancelRequestIfActive();
      return;
    }

    if (text.isNotEmpty || state.searchType == SearchType.Local){
      _createRequest(text, state.searchType);
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
			