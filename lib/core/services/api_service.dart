import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/weather_response.dart';
import '../utils/error_handler.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<WeatherResponse> getWeatherData(String location) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}/weather/$location');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(AppConstants.networkTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherResponse.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } on HttpException {
      throw Exception('Error de servidor HTTP');
    } on FormatException {
      throw Exception('Error en formato de datos');
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }
}