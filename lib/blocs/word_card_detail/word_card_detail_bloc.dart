import 'word_card_detail_event.dart';
import 'word_card_detail_state.dart';
import 'package:bloc/bloc.dart';

class WordCardDetailBloc extends Bloc<WordCardDetailEvent, WordCardDetailState>{

  WordCardDetailState get initialState => null;

  @override
  Stream<WordCardDetailState> mapEventToState(WordCardDetailEvent event) async* {
  }

}
			