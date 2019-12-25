

import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/provider/mock_word_card_db_provider.dart';

class DictionaryRepository{

  final MockWordCardDbProvider _mockWordCardDbProvider = MockWordCardDbProvider();

  Future<List<WordCard>> get() {
    return _mockWordCardDbProvider.fetchCards("");
  }

  Future<void> update(WordCard card)async{
    return Future.microtask((){});
  }
}