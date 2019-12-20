import 'dart:async';
import 'dart:math';
import 'package:app/shared/entity/word_card.dart';

class MockWordCardApiProvider {

  Future<List<WordCard>> fetchCards(String text) {
    return Future<List<WordCard>>.delayed(Duration(seconds: 2), (){
      var random = Random();
      return List<WordCard>.generate(50, (index){
        return WordCard(
          word: "$text $index",
          description: "Description $index",
          translates: ["Translate 1", "Translate 2"],
          imageUrl: "https://picsum.photos/seed/${random.nextInt(50)}/400/300"
        );
      });
    });
  }
}