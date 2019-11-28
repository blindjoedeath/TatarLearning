import 'package:app/shared/entity/language.dart';

import 'search_event.dart';
import 'search_state.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState>{

  SearchState get initialState => SearchState(
    searchLangage: Language.Russian,
    searchType: SearchType.Local
  );

  @override
  Stream<SearchState> transformEvents(Stream<SearchEvent> events, Stream<SearchState> Function(SearchEvent event) next) {
    final observableStream = events as Observable<SearchEvent>;
    final nonDebounceStream = observableStream
      .where((event) {
        return (event is! SearchTextEdited);
      });

    final debounceStates = observableStream
      .where((event) {
        return (event is SearchTextEdited);
      })
      .cast<SearchTextEdited>()
      .debounceTime(Duration(milliseconds: 1000))
      .distinct()
      .switchMap((e){
        var event = SearchTextEditingDone(text: e.text);
        return next(event);
      });

    var nonDebounceStates = super.transformEvents(nonDebounceStream, next) as Observable<SearchState>;
    return nonDebounceStates.mergeWith([debounceStates]);
  }

  Future<String> testSpam(String text){
    return Future.delayed(Duration(seconds: 5), () => text);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchTextEditingDone){
      yield SearchLoading();
      final data = await testSpam(event.text);
      yield SearchDone(text: data);
    } else if (event is SearchLanguageChanged){
      yield* _mapLanguageChanged(event);
    }
  }

  Stream<SearchState> _mapLanguageChanged(SearchEvent event) async* {
    var lang = state.searchLangage == Language.Russian ? Language.Tatar : Language.Russian;
    yield state.copyWith(searchLangage: lang);
  }
}
			