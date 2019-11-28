import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../entity/weather.dart';

class WeatherApiProvider {
  
  Client client = Client();
  final _apiKey = '';

  Future<Weather> fetchCurrentWeather(String city) async {
    final response = await client
        .get("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Weather.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
