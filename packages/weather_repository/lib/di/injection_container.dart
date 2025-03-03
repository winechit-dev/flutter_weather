import 'package:get_it/get_it.dart';
import 'package:open_meteo_api/di/injection_container.dart';
import 'package:weather_repository/src/weather_repository.dart';

final getIt = GetIt.instance;

void initGetIt() {
  initApiGetIt();
  getIt.registerLazySingleton<WeatherRepository>(() => WeatherRepository(weatherApiClient: getIt()));
}
