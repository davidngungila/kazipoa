import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Base API service for all backend communications
class ApiService {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://kazipoa-tanzania.firebaseapp.com/api',
  );

  static const Duration _timeout = Duration(seconds: 30);

  // Headers for authenticated requests
  static Map<String, String> _getHeaders({String? authToken}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-App-Version': '1.0.0',
    };

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  /// Generic GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? authToken,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      final response = await http
          .get(
            uri,
            headers: _getHeaders(authToken: authToken),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    String? authToken,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _getHeaders(authToken: authToken),
            body: data != null ? jsonEncode(data) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    String? authToken,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _getHeaders(authToken: authToken),
            body: data != null ? jsonEncode(data) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? authToken,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _getHeaders(authToken: authToken),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// File upload with multipart request
  static Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    File file, {
    String? authToken,
    Map<String, String>? fields,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl$endpoint'),
      );

      // Add headers
      request.headers.addAll(_getHeaders(authToken: authToken));

      // Add file
      final fileBytes = await file.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Add additional fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      final response = await request.send().timeout(_timeout);
      final responseBody = await response.stream.bytesToString();
      return _handleResponseString(response.statusCode, responseBody);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    if (kDebugMode) {
      print('API Response: $statusCode - $responseBody');
    }

    if (statusCode >= 200 && statusCode < 300) {
      return jsonDecode(responseBody);
    } else {
      throw ApiException(
        message: _getErrorMessage(statusCode, responseBody),
        statusCode: statusCode,
      );
    }
  }

  /// Handle response from file upload
  static Map<String, dynamic> _handleResponseString(int statusCode, String responseBody) {
    if (kDebugMode) {
      print('API Response: $statusCode - $responseBody');
    }

    if (statusCode >= 200 && statusCode < 300) {
      return jsonDecode(responseBody);
    } else {
      throw ApiException(
        message: _getErrorMessage(statusCode, responseBody),
        statusCode: statusCode,
      );
    }
  }

  /// Get error message from response
  static String _getErrorMessage(int statusCode, String responseBody) {
    try {
      final errorData = jsonDecode(responseBody);
      return errorData['message'] ?? 'Unknown error occurred';
    } catch (e) {
      switch (statusCode) {
        case 400:
          return 'Bad request. Please check your input.';
        case 401:
          return 'Unauthorized. Please log in again.';
        case 403:
          return 'Access forbidden. You don\'t have permission.';
        case 404:
          return 'Resource not found.';
        case 429:
          return 'Too many requests. Please try again later.';
        case 500:
          return 'Server error. Please try again later.';
        default:
          return 'Network error occurred. Please check your connection.';
      }
    }
  }

  /// Handle exceptions
  static ApiException _handleError(dynamic error) {
    if (error is SocketException) {
      return ApiException(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } else if (error is HttpException) {
      return ApiException(
        message: 'Network error: ${error.message}',
        statusCode: 0,
      );
    } else if (error.toString().contains('Timeout')) {
      return ApiException(
        message: 'Request timed out. Please try again.',
        statusCode: 0,
      );
    } else {
      return ApiException(
        message: 'Unexpected error: ${error.toString()}',
        statusCode: 0,
      );
    }
  }
}

/// Custom API exception
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
