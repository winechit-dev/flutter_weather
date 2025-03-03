import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

@RestApi(baseUrl: 'https://geocoding-api.open-meteo.com/v1/')
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('/search')
  Future<HttpResponse> locationSearch(
      @Query('name') String query,
      @Query('count') int count
  );
}

class MyCallAdapter<T> extends CallAdapter<Future<T>, Future<Result<T>>> {
  @override
  Future<Result<T>> adapt(Future<T> Function() call) async {
    try {
      final response = await call();
      return Result<T>.ok(response);
    } catch (e) {
      return Result.err(e.toString());
    }
  }
}

class Result<T> {
  final T? data;
  final String? error;

  Result.ok(this.data) : error = null;
  Result.err(this.error) : data = null;
}