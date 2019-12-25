import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];

}
			
class HomeBlocInited extends HomeEvent{}

class WhatIsGamePressed extends HomeEvent{}

class WhichOfGamePressed extends HomeEvent{}

class Showed extends HomeEvent{}

class HeroTransitionDone extends HomeEvent{}