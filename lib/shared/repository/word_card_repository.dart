import 'package:app/blocs/search/search_state.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/provider/mock_word_card_api_provider.dart';
import 'package:app/shared/provider/mock_word_card_db_provider.dart';
import 'package:async/async.dart';

class WordCardSearchRepository{
  final _apiPovider = MockWordCardApiProvider();
  final _dbPovider = MockWordCardDbProvider();

  Future<List<WordCard>> find (String text, SearchType searchType) {
    if(searchType == SearchType.Global){
      return _apiPovider.fetchCards(text);
    }
    return _dbPovider.fetchCards(text);
  }
}