import 'package:app/shared/entity/game_result.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GameOverviewState extends Equatable {

  final GameResult gameResult;
  final List<bool> isWordAdded;

  const GameOverviewState({@required this.gameResult, @required this.isWordAdded});

  @override
  List<Object> get props => [gameResult, isWordAdded];

  GameOverviewState copyWith({GameResult gameResult, List<bool> isWordAdded}){
    return GameOverviewState(
      gameResult: gameResult ?? this.gameResult,
      isWordAdded: isWordAdded ?? this.isWordAdded
    );
  }

}
		