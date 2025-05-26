import 'package:dio/dio.dart';
import '../models/weather_model.dart'; // Import the model class

class WeatherService {
  final Dio _dio;

  WeatherService(this._dio);

  // Fetch weather based on coordinates (latitude and longitude)
  Future<WeatherResponse> fetchWeather(
      double lat, double lon, String apiKey, String units) async {
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': units,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 5),    // Updated timeout
          receiveTimeout: const Duration(seconds: 5), // Updated timeout
        ),
      );

      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timed out. Please try again later.');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception(
            'Failed to load weather data. Status code: ${e.response?.statusCode}');
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception('Network error. Please check your internet connection.');
      } else {
        throw Exception('Unknown error occurred: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  // Fetch weather based on city name
  Future<WeatherResponse> fetchWeatherByCity(
      String cityName, String apiKey, String units) async {
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': cityName,
          'appid': apiKey,
          'units': units,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timed out. Please try again later.');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception(
            'Failed to load weather data. Status code: ${e.response?.statusCode}');
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception('Network error. Please check your internet connection.');
      } else {
        throw Exception('Unknown error occurred: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }
}
