import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../../featcher/model/Api_response_model.dart';
import '../constant/prefs_helper.dart';
import '../utils/app_string.dart';

class ApiService {
  static const int timeOut = 30;

  ///<<<======================== Post Api ==============================>>>

  static Future<ApiResponseModel> postApi(
      String url,
      Object? body, {
        Map<String, String>? header,
      }) async {
    try {
      Map<String, String> mainHeader = {
        'Authorization': PrefsHelper.token,
        'Accept-Language': PrefsHelper.localizationLanguageCode,
        'Content-Type': 'application/json',
      };

      final headers = {
        ...mainHeader,
        if (header != null) ...header,
      };

      debugPrint("URL: $url");
      debugPrint("BODY: $body");
      debugPrint("HEADERS: $headers");

      final response = await http
          .post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers,
      )
          .timeout(const Duration(seconds: timeOut));
      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("RESPONSE BODY: ${response.body}");

      return handleResponse(response);
    } on SocketException {
      return ApiResponseModel(503, AppString.noInternetConnection, {});
    } on FormatException {
      return ApiResponseModel(400, AppString.badResponseRequest, {});
    } on TimeoutException {
      return ApiResponseModel(408, AppString.requestTimeOut, {});
    } catch (e) {
      return ApiResponseModel(
        500,
        "Something went wrong",
        {"error": e.toString()},
      );
    }
  }

  ///<<<======================== Get Api ==============================>>>

  static Future<ApiResponseModel> getApi(
      String url, {
        Map<String, String>? header,
      }) async {
    dynamic responseJson;

    Map<String, String> mainHeader = {
      'Authorization': "Bearer ${PrefsHelper.token}",
      'Accept-Language': PrefsHelper.localizationLanguageCode,
    };

    if (kDebugMode) {
      print("=======================================> url $mainHeader");
      print("=======================================> url $header");
      print("==================================================> url $url");
    }

    try {
      final response = await http
          .get(Uri.parse(url), headers: header ?? mainHeader)
          .timeout(const Duration(seconds: timeOut));
      responseJson = handleResponse(response);
    } on SocketException {
      return ApiResponseModel(503, AppString.noInternetConnection, {});
    } on FormatException {
      return ApiResponseModel(400, AppString.badResponseRequest, {});
    } on TimeoutException {
      return ApiResponseModel(408, AppString.requestTimeOut, {});
    } catch (e) {
      return ApiResponseModel(400, e.toString(), {});
    }
    return responseJson;
  }

  ///<<<======================== Put Api ==============================>>>

  static Future<ApiResponseModel> putApi(
      String url,
      var body, {
        Map<String, String>? header,
      }) async {
    dynamic responseJson;

    Map<String, String> mainHeader = {
      'Authorization': "Bearer ${PrefsHelper.token}",
      'Accept-Language': PrefsHelper.localizationLanguageCode,
    };

    if (kDebugMode) {
      print("=======================================> url $mainHeader");
      print("==================================================> body $body");
      print("==================================================> url $url");
    }

    try {
      final response = await http
          .put(Uri.parse(url), body: body, headers: header ?? mainHeader)
          .timeout(const Duration(seconds: timeOut));
      responseJson = handleResponse(response);
    } on SocketException {
      return ApiResponseModel(503, AppString.noInternetConnection, {});
    } on FormatException {
      return ApiResponseModel(400, AppString.badResponseRequest, {});
    } on TimeoutException {
      return ApiResponseModel(408, AppString.requestTimeOut, {});
    } catch (e) {
      return ApiResponseModel(400, e.toString(), {});
    }
    return responseJson;
  }

  ///<<<======================== Patch Api ==============================>>>

  static Future<ApiResponseModel> patchApi(
      String url, {
        var body,
        Map<String, String>? header,
      }) async {
    dynamic responseJson;

    Map<String, String> mainHeader = {
      'Accept-Language': PrefsHelper.localizationLanguageCode,
      if (PrefsHelper.token.isNotEmpty)
        'Authorization': "Bearer ${PrefsHelper.token}",
    };

    final headers = {
      ...mainHeader,
      if (header != null) ...header,
    };

    if (kDebugMode) {
      debugPrint("=========== PATCH API ===========");
      debugPrint("URL: $url");
      debugPrint("BODY: $body");
      debugPrint("HEADERS: $headers");
    }

    try {
      final response = await http
          .patch(
        Uri.parse(url),
        body: body,
        headers: headers,
      )
          .timeout(const Duration(seconds: timeOut));

      if (kDebugMode) {
        debugPrint("STATUS CODE: ${response.statusCode}");
        debugPrint("RESPONSE BODY: ${response.body}");
      }

      responseJson = handleResponse(response);

    } on SocketException {
      return ApiResponseModel(503, AppString.noInternetConnection, {});
    } on FormatException {
      return ApiResponseModel(400, AppString.badResponseRequest, {});
    } on TimeoutException {
      return ApiResponseModel(408, AppString.requestTimeOut, {});
    } catch (e) {
      return ApiResponseModel(400, e.toString(), {});
    }

    return responseJson;
  }
  ///<<<======================== Delete Api ==============================>>>

  static Future<ApiResponseModel> deleteApi(
      String url, {
        Map<String, String>? body,
        Map<String, String>? header,
      }) async {
    dynamic responseJson;

    Map<String, String> mainHeader = {
      'Authorization': PrefsHelper.token,
      'Accept-Language': PrefsHelper.localizationLanguageCode,
    };

    if (kDebugMode) {
      print("=======================================> url $mainHeader");
      print("==================================================> body $body");
      print("==================================================> url $url");
    }

    try {
      if (body != null) {
        final response = await http
            .delete(Uri.parse(url), body: body, headers: header ?? mainHeader)
            .timeout(const Duration(seconds: timeOut));
        responseJson = handleResponse(response);
      } else {
        final response = await http
            .delete(Uri.parse(url), headers: header ?? mainHeader)
            .timeout(const Duration(seconds: timeOut));
        responseJson = handleResponse(response);
      }
    } on SocketException {
      return ApiResponseModel(503, AppString.noInternetConnection, {});
    } on FormatException {
      return ApiResponseModel(400, AppString.badResponseRequest, {});
    } on TimeoutException {
      return ApiResponseModel(408, AppString.requestTimeOut, {});
    } catch (e) {
      return ApiResponseModel(400, e.toString(), {});
    }
    return responseJson;
  }

  ///<<<================== Api Response Status Code Handle ====================>>>

  static dynamic handleResponse(http.Response response) {
    Map data = jsonDecode(response.body);

    if (kDebugMode) {
      print("========================> statusCode ${response.statusCode}");
      print("========================> body $data");
    }

    switch (response.statusCode) {
      case 200:
        return ApiResponseModel(response.statusCode, data['message'], data);
      case 201:
        return ApiResponseModel(200, data['message'], data);
      case 401:
      // Get.offAllNamed(AppRoutes.signInScreen);
        return ApiResponseModel(response.statusCode, data['message'], data);
      case 400:
        return ApiResponseModel(response.statusCode, data['message'], data);
      case 404:
        return ApiResponseModel(response.statusCode, data['message'], data);
      default:
        return ApiResponseModel(response.statusCode, data['message'], data);
    }
  }

  ///<<<======================== multipartRequest Api ==============================>>>

  static Future<ApiResponseModel> multipartRequest({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? header,
    method = "POST",
    String? imagePath,
    String imageName = 'image',
    required String imagePaths,
  }) async {
    try {
      Map<String, String> mainHeader = {
        'Authorization': "Bearer ${PrefsHelper.token}",
      };

      if (kDebugMode) {
        print("URL => $url");
        print("BODY => $body");
        print("HEADERS => ${header ?? mainHeader}");
        print("METHOD => $method");
        print("IMAGE => $imagePaths");
        print("IMAGE NAME => $imageName");
      }

      var request = http.MultipartRequest(method, Uri.parse(url));

      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (imagePaths.isNotEmpty) {
        final mimeType = lookupMimeType(imagePaths) ?? 'image/jpeg';

        var file = await http.MultipartFile.fromPath(
          imageName,
          imagePaths,
          contentType: MediaType.parse(mimeType),
        );

        request.files.add(file);
      }

      Map<String, String> headers = {
        ...mainHeader,
        if (header != null) ...header,
      };

      request.headers.addAll(headers);

      var response = await request.send();

      if (kDebugMode) {
        print("STATUS CODE => ${response.statusCode}");
      }

      String data = await response.stream.bytesToString();
      var mapData = jsonDecode(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponseModel(
          200,
          mapData['message'] ?? "Success",
          mapData,
        );
      } else {
        return ApiResponseModel(
          response.statusCode,
          mapData['message'] ?? "Error",
          mapData,
        );
      }
    } on SocketException {
      return ApiResponseModel(503, AppString.noInternetConnection, {});
    } on FormatException {
      return ApiResponseModel(400, AppString.badResponseRequest, {});
    } on TimeoutException {
      return ApiResponseModel(408, AppString.requestTimeOut, {});
    } catch (e) {
      return ApiResponseModel(500, e.toString(), {});
    }
  }

  ///<<<======================== multipartRequest Api ==============================>>>

  static Future<ApiResponseModel> multipartRequestBody({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? header,
    String method = "PUT",
    Map<String, dynamic>? imagePaths, // key = field name, value = image path
  }) async {
    try {
      Map<String, String> mainHeader = {
        'Authorization': "Bearer ${PrefsHelper.token}",
      };

      if (kDebugMode) {
        print("==========> URL: $url");
        print("==========> Body: $body");
        print("==========> Headers: ${header ?? mainHeader}");
        print("==========> Method: $method");
        print("==========> ImagePaths: $imagePaths");
      }

      var request = http.MultipartRequest(method, Uri.parse(url));

      // Add form fields
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Attach multiple named images
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (var entry in imagePaths.entries) {
          String fieldName = entry.key;
          String path = entry.value;
          log("fieldname========$fieldName");
          final mimeType = lookupMimeType(path) ?? 'image/jpeg';

          final file = await http.MultipartFile.fromPath(
            fieldName,
            path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(file);
        }
      }

      // Add headers
      request.headers.addAll(header ?? mainHeader);

      var response = await request.send();

      if (kDebugMode) {
        print("==========> StatusCode: ${response.statusCode}");
      }

      String responseBody = await response.stream.bytesToString();
      var mapData = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponseModel(200, mapData['message'], mapData);
      } else {
        return ApiResponseModel(
          response.statusCode,
          mapData['message'],
          mapData,
        );
      }
    } on SocketException {
      return ApiResponseModel(503, AppString.noInternetConnection, {});
    } on FormatException {
      return ApiResponseModel(400, AppString.badResponseRequest, {});
    } on TimeoutException {
      return ApiResponseModel(408, AppString.requestTimeOut, {});
    } catch (e) {
      return ApiResponseModel(400, e.toString(), {});
    }
  }

  static Future<ApiResponseModel> completeProfileBody({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? header,
    String method = "PUT",
    Map<String, dynamic>? imagePaths,
  }) async {
    try {
      Map<String, String> mainHeader = {
        'Authorization': "Bearer ${PrefsHelper.token}",
      };

      if (kDebugMode) {
        print("==========> URL: $url");
        print("==========> Body (RAW): $body");
        print("==========> Headers: ${header ?? mainHeader}");
        print("==========> Method: $method");
        print("==========> ImagePaths: $imagePaths");
      }

      var request = http.MultipartRequest(method, Uri.parse(url));

      body.forEach((key, value) {
        if (value == null) return;

        if (value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (var entry in imagePaths.entries) {
          String fieldName = entry.key;
          String path = entry.value;

          final mimeType = lookupMimeType(path) ?? 'image/jpeg';

          final file = await http.MultipartFile.fromPath(
            fieldName,
            path,
            contentType: MediaType.parse(mimeType),
          );

          request.files.add(file);
        }
      }

      request.headers.addAll(header ?? mainHeader);

      if (kDebugMode) {
        request.fields.forEach((k, v) {
          print("FIELD => $k : $v");
        });
      }
      print("SOMETHINGS MIGHT NEED MOOOOOOOOOREE: ${request.fields}");
      var response = await request.send();

      if (kDebugMode) {
        print("==========> StatusCode: ${response.statusCode}");
      }

      String responseBody = await response.stream.bytesToString();
      var mapData = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponseModel(
          response.statusCode,
          mapData['message'],
          mapData,
        );
      } else {
        return ApiResponseModel(
          response.statusCode,
          mapData['message'],
          mapData,
        );
      }
    } on SocketException {
      return ApiResponseModel(503, AppString.noInternetConnection, {});
    } on FormatException {
      return ApiResponseModel(400, AppString.badResponseRequest, {});
    } on TimeoutException {
      return ApiResponseModel(408, AppString.requestTimeOut, {});
    } catch (e) {
      return ApiResponseModel(400, e.toString(), {});
    }
  }

  ///<<<======================== multipartRequest Api ==============================>>>

  static Future<ApiResponseModel> rajuMultipart({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? header,
    String method = "PUT",
    required List<String> imagePaths, // key = field name, value = image path
  }) async {
    try {
      Map<String, String> mainHeader = {
        'Authorization': "Bearer ${PrefsHelper.token}",
      };

      if (kDebugMode) {
        print("==========> URL: $url");
        print("==========> Body: $body");
        print("==========> Headers: ${header ?? mainHeader}");
        print("==========> Method: $method");
        print("==========> ImagePaths: $imagePaths");
      }

      var request = http.MultipartRequest(method, Uri.parse(url));

      // Add form fields
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Attach multiple named images
      if (imagePaths.isNotEmpty) {
        for (var entry in imagePaths) {
          String fieldName = "image";
          String path = entry;
          log("fieldname========$fieldName");
          final mimeType = lookupMimeType(path) ?? 'image/jpeg';

          final file = await http.MultipartFile.fromPath(
            fieldName,
            path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(file);
        }
      }

      // Add headers
      request.headers.addAll(header ?? mainHeader);

      var response = await request.send();

      if (kDebugMode) {
        print("==========> StatusCode: ${response.statusCode}");
      }

      String responseBody = await response.stream.bytesToString();
      var mapData = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponseModel(200, mapData['message'], mapData);
      } else {
        return ApiResponseModel(
          response.statusCode,
          mapData['message'],
          mapData,
        );
      }
    } on SocketException {
      return ApiResponseModel(503, AppString.noInternetConnection, {});
    } on FormatException {
      return ApiResponseModel(400, AppString.badResponseRequest, {});
    } on TimeoutException {
      return ApiResponseModel(408, AppString.requestTimeOut, {});
    } catch (e) {
      return ApiResponseModel(400, e.toString(), {});
    }
  }
}
