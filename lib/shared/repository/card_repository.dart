import 'package:app/blocs/search/search_state.dart';
import 'package:app/shared/provider/mock_card_api_provider.dart';
import 'package:app/shared/provider/mock_card_db_provider.dart';

import '../provider/weather_api_provider.dart';
import '../entity/card.dart';

class CardSearchRepository{
  final _apiPovider = MockCardApiProvider();
  final _dbPovider = MockCardDbProvider();

  Future<List<Card>> find (String text, SearchType searchType) {
    if(searchType == SearchType.Global){
      return _apiPovider.fetchCards(text);
    }
    return _dbPovider.fetchCards(text);
  }
}