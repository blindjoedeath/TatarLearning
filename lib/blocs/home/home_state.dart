import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];

}

class HomeIsNotInited extends HomeState{}

class HomeDefaultState extends HomeState{
  final bool withHeros;

  const HomeDefaultState({this.withHeros = true});
}

class ShowWhatIsGame extends HomeState{}
			