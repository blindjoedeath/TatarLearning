import 'dart:convert';
import 'clouds.dart';
import 'coord.dart';
import 'sys.dart';
import 'weather_element.dart';
import 'weather_main.dart';
import 'wind.dart';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
    final Coord coord;
    final List<WeatherElement> weather;
    final String base;
    final Main main;
    final int visibility;
    final Wind wind;
    final Clouds clouds;
    final int dt;
    final Sys sys;
    final int timezone;
    final int id;
    final String name;
    final int cod;

    Weather({
        this.coord,
        this.weather,
        this.base,
        this.main,
        this.visibility,
        this.wind,
        this.clouds,
        this.dt,
        this.sys,
        this.timezone,
        this.id,
        this.name,
        this.cod,
    });

    factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        coord: Coord.fromJson(json["coord"]),
        weather: List<WeatherElement>.from(json["weather"].map((x) => WeatherElement.fromJson(x))),
        base: json["base"],
        main: Main.fromJson(json["main"]),
        visibility: json["visibility"],
        wind: Wind.fromJson(json["wind"]),
        clouds: Clouds.fromJson(json["clouds"]),
        dt: json["dt"],
        sys: Sys.fromJson(json["sys"]),
        timezone: json["timezone"],
        id: json["id"],
        name: json["name"],
        cod: json["cod"],
    );

    Map<String, dynamic> toJson() => {
        "coord": coord.toJson(),
        "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
        "base": base,
        "main": main.toJson(),
        "visibility": visibility,
        "wind": wind.toJson(),
        "clouds": clouds.toJson(),
        "dt": dt,
        "sys": sys.toJson(),
        "timezone": timezone,
        "id": id,
        "name": name,
        "cod": cod,
    };
}