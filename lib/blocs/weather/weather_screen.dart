import 'package:app/blocs/weather/weather_builder.dart';

import 'weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_state.dart';
import 'weather_event.dart';


class WeatherScreen extends StatelessWidget {

  final WeatherBloc weatherBloc;

  const WeatherScreen({@required this.weatherBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather"),),
      body: Center(
        child: Column(
          children: <Widget>[
             BlocBuilder<WeatherBloc, WeatherState>(
              bloc: weatherBloc,
              builder: (context, state){
                if (state is WeatherEmpty){
                  return Text("weatherEmpty");
                } else if(state is WeatherLoading){
                  return Text("weather loading");
                } else if(state is WeatherLoaded){
                  return Text(state.weather.weather[0].description);
                }
                return Text("empty");
              },
            ),
            RaisedButton(
              onPressed: (){
                weatherBloc.add(FetchWeather(
                  city: "Казань"
                ));
              },
            ),
            RaisedButton(
              color: Colors.red,
              onPressed: (){
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context){
                    return WeatherBuilder();
                  })
                );
              },
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            TextField(
              autocorrect: false,
            )
          ],
        )
      )
    );
  }
}