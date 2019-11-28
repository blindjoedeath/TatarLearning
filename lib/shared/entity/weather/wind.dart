class Wind {
    final int speed;
    final int deg;
    final int gust;

    Wind({
        this.speed,
        this.deg,
        this.gust,
    });

    factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: json["speed"],
        deg: json["deg"],
        gust: json["gust"],
    );

    Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
        "gust": gust,
    };
}
