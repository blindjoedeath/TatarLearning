import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class WordCardDetailState extends Equatable {

  final bool wordAdded;
  const WordCardDetailState({@required this.wordAdded});

  @override
  List<Object> get props => [wordAdded];


  WordCardDetailState copyWith({bool wordAdded}){
    return WordCardDetailState(
      wordAdded: wordAdded ?? this.wordAdded
    );
  }

}


