import 'package:app/blocs/weather/weather_screen.dart';
import 'package:app/shared/repository/weather_repository.dart';
import 'weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBuilder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherBuilderState();
}

class _WeatherBuilderState extends State<WeatherBuilder>{

  WeatherBloc bloc;
  @override
  void initState() {
    bloc = WeatherBloc(
      weatherRepository:  RepositoryProvider.of<WeatherRepository>(context)
    );
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    bloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeatherBloc>.value(
      value: bloc,
      child: WeatherScreen(
        weatherBloc: bloc,
      ),
    );
  }
}