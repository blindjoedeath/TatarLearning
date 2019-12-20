import 'dart:async';
import 'package:app/shared/entity/quiz_card.dart';

class MockQuizCardProvider {

  Future<List<QuizCard>> fetchCards() {
   return Future<List<QuizCard>>.delayed(Duration(milliseconds: 1500), (){
      return List<QuizCard>.generate(10, (index){
        return QuizCard(
          answerIndex: 0,
          variants: ["variant 1", "variant 2, variant 3, variant 4"],
          imageUrl: "http://sun9-14.userapi.com/c849424/v849424786/15eee3/Y4C7mfELwBA.jpg?ava=1"
        );
      });
    });
  }
}