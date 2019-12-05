import 'dart:async';
import 'package:app/shared/entity/word_card.dart';

class MockWordCardApiProvider {

  Future<List<WordCard>> fetchCards(String text) {
    return Future<List<WordCard>>.delayed(Duration(seconds: 2), (){
      return List<WordCard>.generate(10, (index){
        return WordCard(
          word: "$text $index",
          description: "Description $index",
          translates: ["Translate 1", "Translate 2"],
          imageUrl: "http://sun9-14.userapi.com/c849424/v849424786/15eee3/Y4C7mfELwBA.jpg?ava=1"
        );
      });
    });
  }
}