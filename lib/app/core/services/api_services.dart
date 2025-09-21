// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eduline/app/core/networks/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Configuration - Change these for your project
  static const String baseUrl = URLs.baseUrl;
  static const Duration timeout = Duration(seconds: 15);

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Base headers
  static const Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Get headers with token
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = Map<String, String>.from(_baseHeaders);

    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Build full URL
  String _buildUrl(String endpoint) {
    if (endpoint.startsWith('http')) {
      return endpoint;
    }
    return '$baseUrl$endpoint';
  }

  // Token management
  // Save token with remember me option
  Future<void> saveTokenWithRemember(String token, bool rememberMe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, token);
      await prefs.setBool('remember_me', rememberMe);
    } catch (e) {
      print('Error saving token with remember: $e');
    }
  }

  // Check if user chose remember me
  Future<bool> shouldRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('remember_me') ?? false;
    } catch (e) {
      print('Error getting remember me: $e');
      return false;
    }
  }

  // Modified clearTokens for remember me
  Future<void> clearTokens({bool clearRememberMe = true}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);

      if (clearRememberMe) {
        await prefs.remove('remember_me');
      }
    } catch (e) {
      print('Error clearing tokens: $e');
    }
  }

  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenKey, refreshToken);
    } catch (e) {
      print('Error saving refresh token: $e');
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      print('Error getting refresh token: $e');
      return null;
    }
  }

  // Original clearTokens method (deprecated - use the one above)
  Future<void> clearTokensOld() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
    } catch (e) {
      print('Error clearing tokens: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    try {
      final data = jsonDecode(response.body);

      if (statusCode >= 200 && statusCode < 300) {
        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Success',
          'statusCode': statusCode,
        };
      } else {
        final errorMessage =
            data['message'] ?? data['error'] ?? 'An error occurred';

        // Handle token expiration
        if (statusCode == 401) {
          clearTokens();
        }

        return {
          'success': false,
          'message': errorMessage,
          'statusCode': statusCode,
          'data': data,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Invalid response format',
        'statusCode': statusCode,
        'data': response.body,
      };
    }
  }

  // Handle exceptions
  Map<String, dynamic> _handleException(dynamic e) {
    String message;

    if (e is SocketException) {
      message = 'No internet connection';
    } else if (e is TimeoutException) {
      message = 'Request timeout. Please try again.';
    } else if (e is HttpException) {
      message = 'Network error occurred';
    } else if (e is FormatException) {
      message = 'Invalid response format';
    } else {
      message = 'Unexpected error: ${e.toString()}';
    }

    return {'success': false, 'message': message, 'statusCode': 0};
  }

  // GET Request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool includeAuth = true,
  }) async {
    try {
      Uri uri = Uri.parse(_buildUrl(endpoint));

      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http.get(uri, headers: headers).timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // POST Request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool includeAuth = true,
  }) async {
    try {
      Uri uri = Uri.parse(_buildUrl(endpoint));

      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // PUT Request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool includeAuth = true,
  }) async {
    try {
      Uri uri = Uri.parse(_buildUrl(endpoint));

      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http
          .put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // PATCH Request
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool includeAuth = true,
  }) async {
    try {
      Uri uri = Uri.parse(_buildUrl(endpoint));

      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http
          .patch(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // DELETE Request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? queryParams,
    bool includeAuth = true,
  }) async {
    try {
      Uri uri = Uri.parse(_buildUrl(endpoint));

      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http
          .delete(uri, headers: headers)
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // Refresh token method
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await post(
        '/auth/refresh',
        body: {'refreshToken': refreshToken},
        includeAuth: false,
      );

      if (response['success']) {
        final data = response['data'];
        final newAccessToken = data['accessToken'] ?? data['access_token'];
        final newRefreshToken = data['refreshToken'] ?? data['refresh_token'];

        if (newAccessToken != null) {
          await saveToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          await saveRefreshToken(newRefreshToken);
        }

        return true;
      }

      return false;
    } catch (e) {
      print('Token refresh failed: $e');
      return false;
    }
  }

  // Generic request method for special cases
  Future<Map<String, dynamic>> request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Map<String, String>? extraHeaders,
    bool includeAuth = true,
  }) async {
    try {
      Uri uri = Uri.parse(_buildUrl(endpoint));

      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(includeAuth: includeAuth);
      if (extraHeaders != null) {
        headers.addAll(extraHeaders);
      }

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers).timeout(timeout);
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
          break;
        case 'PATCH':
          response = await http
              .patch(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers).timeout(timeout);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }
}
