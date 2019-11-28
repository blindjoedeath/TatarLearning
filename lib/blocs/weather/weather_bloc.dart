import 'package:app/shared/repository/weather_repository.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState>{

  final WeatherRepository weatherRepository;

  WeatherBloc({@required this.weatherRepository}) : assert(weatherRepository != null);

  WeatherState get initialState => WeatherEmpty();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
      if(event is FetchWeather){
        yield WeatherLoading();
      try{
        final weather = await weatherRepository.fetchCurrentWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch(_){
        yield WeatherError();
      }
    }
  }
}