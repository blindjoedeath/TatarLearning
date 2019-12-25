import 'dart:async';
import 'dart:math';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/entity/word_card.dart';

class MockQuizCardProvider {


  List<QuizCard> get mockCards => 
    List<QuizCard>.generate(10, (index){
    return QuizCard(
      answerIndex: 0,
      variants: [
        _mockCard("Песи"),
        _mockCard("Эт"),
        _mockCard("Чәк чәк"),
        _mockCard("Чикләвек")
      ],
    );
  });

  Future<List<QuizCard>> fetchCards() {
   return Future<List<QuizCard>>.delayed(Duration(milliseconds: 1500), (){
      return mockCards;
    });
  }

  WordCard _mockCard(String word){
    var random = Random();
    return WordCard(
      word: word,
      description: "Description",
      translates: ["Translate 1", "Translate 2"],
      imageUrl: "https://picsum.photos/seed/${random.nextInt(50)}/400/300"
    );
  }
}