class AppConstants {
  static const String baseUrl = 'https://fastapi-example-ttuw.onrender.com';
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration refreshInterval = Duration(minutes: 10);

  static const List<String> availableLocations = [
    'suchiapa',
    'tuxtla',
    'ocozocoautla',
    'apicpac'
  ];

  static const Map<String, String> locationNames = {
    'suchiapa': 'Suchiapa',
    'tuxtla': 'Tuxtla Gutiérrez',
    'ocozocoautla': 'Ocozocoautla',
    'apicpac': 'Embarcadero Apicpac',
  };
}