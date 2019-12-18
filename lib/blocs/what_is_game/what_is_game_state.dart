import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WhatIsGameState extends Equatable {
  const WhatIsGameState();

  @override
  List<Object> get props => [];

}

class ShowIntro extends WhatIsGameState{}

class ShowGame extends WhatIsGameState{}