import '../models/weather_response.dart';

abstract class WeatherServiceInterface {
  Future<WeatherResponse> getWeatherData(String location);
}