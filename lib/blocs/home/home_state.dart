import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];

}

class HomeIsNotInited extends HomeState{}

class HomeDefaultState extends HomeState{}

class ShowWhatIsGame extends HomeState{}
			