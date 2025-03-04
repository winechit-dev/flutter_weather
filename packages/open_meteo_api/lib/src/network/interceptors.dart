import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(printer: PrettyPrinter(methodCount: 0, colors: true,printEmojis: true));

  @override
  void onError( DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = options.baseUrl;
    logger.e('${options.method} request ==> $requestPath'); //Error log
    logger.d('Error type: ${err.error} \n '
        'Error message: ${err.message}'); //Debug log
    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = options.path;
    final queryParams = options.queryParameters;

    logger.i('${options.method} request ==> $requestPath?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'); // Info log
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('STATUS_CODE: ${response.statusCode} \n '
        'STATUS_MESSAGE: ${response.statusMessage} \n'
        'HEADERS: ${response.headers} \n'
        'Data: ${response.data}'); // Debug log
    handler.next(response); // continue with the Response
  }
}


/*
class AuthorizationInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    //final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // final token  = sharedPreferences.getString('token');
    // options.headers['Authorization'] = "Bearer $token";
    options.queryParameters['api_key'] = ApiUrl.apiKey;
    handler.next(options); // continue with the Request
  }
}*/
