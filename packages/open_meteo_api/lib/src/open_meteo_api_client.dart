import 'dart:async';
import 'package:logger/logger.dart';
import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:open_meteo_api/src/retrofit_client.dart';

/// Exception thrown when locationSearch fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}

/// {@template open_meteo_api_client}
/// Dart API Client which wraps the [Open Meteo API](https://open-meteo.com).
/// {@endtemplate}
class OpenMeteoApiClient {
  /// {@macro open_meteo_api_client}
  OpenMeteoApiClient({required RestClient client})
      : _retrofitClient = client;

  final logger = Logger();

  final RestClient _retrofitClient;

  Future<Location> locationSearch(String query) async {

    final locationResponse = await _retrofitClient.locationSearch(query, 1);

    if (locationResponse.response.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final locationJson = locationResponse.data as Map<String, dynamic>;

    if (!locationJson.containsKey('results')) throw LocationNotFoundFailure();

    final results = locationJson['results'] as List;

    if (results.isEmpty) throw LocationNotFoundFailure();

    return Location.fromJson(results.first as Map<String, dynamic>);
  }

  /// Fetches [Weather] for a given [latitude] and [longitude].
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherResponse = await _retrofitClient.getWeather(latitude, longitude);

    if (weatherResponse.response.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final weather = weatherResponse.data as Map<String, dynamic>;

    if (!weather.containsKey('current_weather')) {
      throw WeatherNotFoundFailure();
    }

    final weatherJson = weather['current_weather'] as Map<String, dynamic>;

    return Weather.fromJson(weatherJson);
  }

}
