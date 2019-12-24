import 'package:app/blocs/search/search_state.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/provider/mock_word_card_api_provider.dart';
import 'package:app/shared/provider/word_card_db_provider.dart';
import 'package:async/async.dart';

class WordCardRepository{
  final _apiPovider = MockWordCardApiProvider();
  final _dbPovider = WordCardDbProvider();

  bool get isInited => _dbPovider.isInited;

  Future<void> init()async{
    return await _dbPovider.init();
  }

  void dispose(){
    _dbPovider.dispose();
  }

  Future<List<WordCard>> find (String text, SearchType searchType) {
    if(searchType == SearchType.Global){
      return _apiPovider.fetchCards(text);
    }
    return _dbPovider.fetchCards(text);
  }

  bool containsLocal(WordCard card){
    return _dbPovider.contains(card);
  }

  Future<void> deleteLocalIfContains(WordCard card)async{
    if (containsLocal(card)){
      return await _dbPovider.delete(card);
    }
  }

  Future<void> addLocalIfNotContains(WordCard card)async{
    if (!containsLocal(card)){
      return await _dbPovider.save(card);
    }
  }
}