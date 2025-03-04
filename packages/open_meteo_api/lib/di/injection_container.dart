
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../open_meteo_api.dart';
import '../src/network/dio_client.dart';
import '../src/retrofit_client.dart';

final getIt = GetIt.instance;

void initApiGetIt() {
  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<RestClient>(RestClient(getIt()));

  getIt.registerLazySingleton<OpenMeteoApiClient>(() => OpenMeteoApiClient(client: getIt()));
}