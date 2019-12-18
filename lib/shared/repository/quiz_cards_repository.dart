import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/provider/mock_quiz_card_provider.dart';
class QuizCardsRepository{
  final _cardsProvider = MockQuizCardProvider();

  Future<List<QuizCard>> getCards() {
    return _cardsProvider.fetchCards();
  }
}