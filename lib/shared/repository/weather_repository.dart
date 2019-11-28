import '../provider/weather_api_provider.dart';
import '../entity/weather.dart';

class WeatherRepository{
  final provider = WeatherApiProvider();

  Future<Weather> fetchCurrentWeather(String city){
    return provider.fetchCurrentWeather(city);
  }
}