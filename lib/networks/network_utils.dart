import 'dart:convert';
import 'dart:io';

import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/model_keys.dart';

Map<String, String> buildHeaderTokens() {
  Map<String, String> header = {};

  if (appStore.isLoggedIn) header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
  header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
  header.addAll(defaultHeaders());

  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$BASE_URL$endPoint');

  log('URL: ${url.toString()}');

  return url;
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map<String, String>? header,
}) async {
  var headers = header ?? buildHeaderTokens();
  Uri url = buildBaseUrl(endPoint);

  Response response;

  try {
    if (method == HttpMethodType.POST) {
      // log('Request: ${jsonEncode(request)}');
      response = await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethodType.POST || method == HttpMethodType.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: method.name,
    );
    // log('Response (${method.name}) ${response.statusCode}: ${response.body}');

    if (appStore.isLoggedIn && response.statusCode == 401 && !endPoint.startsWith('http')) {
      return await reGenerateToken().then((value) async {
        return await buildHttpResponse(endPoint, method: method, request: request, header: header);
      }).catchError((e) {
        throw errorSomethingWentWrong;
      });
    } else {
      return response;
    }
  } on Exception catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw errorInternetNotAvailable;
    } else {
      throw errorSomethingWentWrong;
    }
  }
}

Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 400) {
    throw '${languages.badRequest}';
  } else if (response.statusCode == 403) {
    throw '${languages.forbidden}';
  } else if (response.statusCode == 404) {
    throw '${languages.pageNotFound}';
  } else if (response.statusCode == 429) {
    throw '${languages.tooManyRequests}';
  } else if (response.statusCode == 500) {
    throw '${languages.internalServerError}';
  } else if (response.statusCode == 502) {
    throw '${languages.badGateway}';
  } else if (response.statusCode == 503) {
    throw '${languages.serviceUnavailable}';
  } else if (response.statusCode == 504) {
    throw '${languages.gatewayTimeout}';
  }

  if (httpResponseType == HttpResponseType.JSON) {
    if (response.body.isJson()) {
      var body = jsonDecode(response.body);

      if (response.statusCode.isSuccessful()) {
        if (body is Map && body.containsKey('status') && !body['status']) {
          throw parseHtmlString(body['message'] ?? errorSomethingWentWrong);
        } else {
          return body;
        }
      } else {
        throw parseHtmlString(body['message'] ?? errorSomethingWentWrong);
      }
    } else {
      throw errorSomethingWentWrong;
    }
  } else if (httpResponseType == HttpResponseType.BODY_BYTES) {
    return response.bodyBytes;
  } else if (httpResponseType == HttpResponseType.FULL_RESPONSE) {
    return response;
  } else if (httpResponseType == HttpResponseType.STRING) {
    return response.body;
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<Map<String, dynamic>> handleSadadResponse(Response res) async {
  if (res.body.isJson()) {
    var body = jsonDecode(res.body);

    if (res.statusCode.isSuccessful()) {
      return body;
    } else {
      throw parseHtmlString(body['error']['message']);
    }
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<void> reGenerateToken() async {
  log('Regenerating Token');
  Map req = {
    UserKeys.email: appStore.userEmail,
    UserKeys.password: getStringAsync(USER_PASSWORD),
  };

  return await loginUser(req).then((value) async {
    await appStore.setToken(value.apiToken.validate());
  }).catchError((e) {
    log(e);
    throw e;
  });
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());

  apiPrint(
      url: multiPartRequest.url.toString(),
      headers: jsonEncode(multiPartRequest.headers),
      request: jsonEncode(multiPartRequest.fields),
      hasRequest: true,
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: "MultiPart");
  // log('response : ${response.body}');

  if (response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      onSuccess?.call(response.body);
    } else {
      onSuccess?.call(response.body);
    }
  } else {
    try {
      if (response.body.isJson()) {
        var body = jsonDecode(response.body);
        onError?.call(body['message'] ?? errorSomethingWentWrong);
      } else {
        onError?.call(errorSomethingWentWrong);
      }
    } on Exception catch (e) {
      log(e);
      onError?.call(errorSomethingWentWrong);
    }
  }
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
}) {
  log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
  log("\u001b[93mUrl: \u001B[39m $url");
  log("\u001b[93mHeader: \u001B[39m \u001b[96m$headers\u001B[39m");
  if (request.isNotEmpty) log("\u001b[93mRequest: \u001B[39m \u001b[96m$request\u001B[39m");
  log('Response ($methodtype) $statusCode: $responseBody');
  log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
}

Map<String, String> buildHeaderForStripe(String stripeKeyPayment) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/x-www-form-urlencoded');
  header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $stripeKeyPayment');

  return header;
}

Map<String, String> buildHeaderForSadad({String? sadadToken}) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json');
  if (sadadToken != null) header.putIfAbsent(HttpHeaders.authorizationHeader, () => sadadToken);

  return header;
}

Map<String, String> buildHeaderForFlutterWave(String flutterWaveSecretKey) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");

  return header;
}

Map<String, String> buildHeaderForAirtelMoney(String accessToken, String XCountry, String XCurrency) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
  header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $accessToken');
  header.putIfAbsent('X-Country', () => '$XCountry');
  header.putIfAbsent('X-Currency', () => '$XCurrency');

  return header;
}

Map<String, String> defaultHeaders() {
  Map<String, String> header = {};

  header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
  header.putIfAbsent('Access-Control-Allow-Headers', () => '*');
  header.putIfAbsent('Access-Control-Allow-Origin', () => '*');

  return header;
}
