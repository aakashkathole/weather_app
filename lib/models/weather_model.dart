class WeatherResponse {
  final String name;
  final Main main;
  final List<Weather> weather;
  final Wind wind;

  const WeatherResponse({
    required this.name,
    required this.main,
    required this.weather,
    required this.wind,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      name: json['name'] ?? '', // Default empty string if name is null
      main: Main.fromJson(json['main']),
      weather: (json['weather'] as List?)?.map((i) => Weather.fromJson(i)).toList() ?? [],
      wind: Wind.fromJson(json['wind']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'main': main.toJson(),
      'weather': weather.map((i) => i.toJson()).toList(),
      'wind': wind.toJson(),
    };
  }
}

class Main {
  final double temp;
  final int humidity;

  const Main({
    required this.temp,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp']?.toDouble() ?? 0.0, // Default value if temp is missing or null
      humidity: json['humidity'] ?? 0, // Default value if humidity is missing or null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'humidity': humidity,
    };
  }
}

class Weather {
  final String description;

  const Weather({required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['description'] ?? '', // Default empty string if description is missing or null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
}

class Wind {
  final double speed;

  const Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed']?.toDouble() ?? 0.0, // Default value if speed is missing or null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
    };
  }
}
