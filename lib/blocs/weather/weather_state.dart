import 'package:app/shared/entity/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class WeatherState extends Equatable{
  const WeatherState();

  @override get props => [];
}

class WeatherEmpty extends WeatherState{}

class WeatherLoading extends WeatherState{}

class WeatherLoaded extends WeatherState{
  final Weather weather;

  const WeatherLoaded({@required this.weather}) : assert(weather != null);

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState{}