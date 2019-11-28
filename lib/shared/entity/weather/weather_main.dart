class Main {
    final double temp;
    final int pressure;
    final int humidity;
    final double tempMin;
    final double tempMax;

    Main({
        this.temp,
        this.pressure,
        this.humidity,
        this.tempMin,
        this.tempMax,
    });

    factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: json["temp"].toDouble(),
        pressure: json["pressure"],
        humidity: json["humidity"],
        tempMin: json["temp_min"].toDouble(),
        tempMax: json["temp_max"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "temp": temp,
        "pressure": pressure,
        "humidity": humidity,
        "temp_min": tempMin,
        "temp_max": tempMax,
    };
}