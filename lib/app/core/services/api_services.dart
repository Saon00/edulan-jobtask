// // lib/services/api_service.dart
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/app_config.dart';
// import '../models/api_response.dart';

// class ApiService {
//   // Singleton pattern
//   static final ApiService _instance = ApiService._internal();
//   factory ApiService() => _instance;
//   ApiService._internal();

//   // Configuration
//   static const Duration _timeout = Duration(seconds: 30);
//   static const String _tokenKey = 'access_token';
//   static const String _refreshTokenKey = 'refresh_token';

//   // Base headers
//   static const Map<String, String> _baseHeaders = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//   };

//   // Cache for SharedPreferences
//   SharedPreferences? _prefs;

//   // Initialize SharedPreferences
//   Future<void> init() async {
//     _prefs ??= await SharedPreferences.getInstance();
//   }

//   // Get SharedPreferences instance
//   Future<SharedPreferences> get _preferences async {
//     await init();
//     return _prefs!;
//   }

//   // Token management
//   Future<String?> getToken() async {
//     try {
//       final prefs = await _preferences;
//       return prefs.getString(_tokenKey);
//     } catch (e) {
//       print('Error getting token: $e');
//       return null;
//     }
//   }

//   Future<void> saveToken(String token) async {
//     try {
//       final prefs = await _preferences;
//       await prefs.setString(_tokenKey, token);
//     } catch (e) {
//       print('Error saving token: $e');
//     }
//   }

//   Future<String?> getRefreshToken() async {
//     try {
//       final prefs = await _preferences;
//       return prefs.getString(_refreshTokenKey);
//     } catch (e) {
//       print('Error getting refresh token: $e');
//       return null;
//     }
//   }

//   Future<void> saveRefreshToken(String refreshToken) async {
//     try {
//       final prefs = await _preferences;
//       await prefs.setString(_refreshTokenKey, refreshToken);
//     } catch (e) {
//       print('Error saving refresh token: $e');
//     }
//   }

//   Future<void> clearTokens() async {
//     try {
//       final prefs = await _preferences;
//       await prefs.remove(_tokenKey);
//       await prefs.remove(_refreshTokenKey);
//     } catch (e) {
//       print('Error clearing tokens: $e');
//     }
//   }

//   Future<bool> isLoggedIn() async {
//     final token = await getToken();
//     return token != null && token.isNotEmpty;
//   }

//   // Build headers with authentication
//   Future<Map<String, String>> _buildHeaders({
//     Map<String, String>? extraHeaders,
//     bool includeAuth = true,
//   }) async {
//     final headers = Map<String, String>.from(_baseHeaders);

//     if (includeAuth) {
//       final token = await getToken();
//       if (token != null && token.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $token';
//       }
//     }

//     if (extraHeaders != null) {
//       headers.addAll(extraHeaders);
//     }

//     return headers;
//   }

//   // Build full URL
//   String _buildUrl(String endpoint) {
//     if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
//       return endpoint;
//     }
//     return '${AppConfig.baseUrl}$endpoint';
//   }

//   // Generic HTTP method handler
//   Future<ApiResponse<T>> _makeRequest<T>(
//       String method,
//       String endpoint, {
//         Map<String, dynamic>? body,
//         Map<String, String>? queryParams,
//         Map<String, String>? extraHeaders,
//         bool includeAuth = true,
//         T Function(dynamic)? fromJson,
//       }) async {
//     try {
//       // Build URL with query parameters
//       Uri uri = Uri.parse(_buildUrl(endpoint));
//       if (queryParams != null && queryParams.isNotEmpty) {
//         uri = uri.replace(queryParameters: queryParams);
//       }

//       // Build headers
//       final headers = await _buildHeaders(
//         extraHeaders: extraHeaders,
//         includeAuth: includeAuth,
//       );

//       // Make HTTP request
//       http.Response response;
//       switch (method.toUpperCase()) {
//         case 'GET':
//           response = await http.get(uri, headers: headers).timeout(_timeout);
//           break;
//         case 'POST':
//           response = await http
//               .post(
//             uri,
//             headers: headers,
//             body: body != null ? jsonEncode(body) : null,
//           )
//               .timeout(_timeout);
//           break;
//         case 'PUT':
//           response = await http
//               .put(
//             uri,
//             headers: headers,
//             body: body != null ? jsonEncode(body) : null,
//           )
//               .timeout(_timeout);
//           break;
//         case 'PATCH':
//           response = await http
//               .patch(
//             uri,
//             headers: headers,
//             body: body != null ? jsonEncode(body) : null,
//           )
//               .timeout(_timeout);
//           break;
//         case 'DELETE':
//           response = await http.delete(uri, headers: headers).timeout(_timeout);
//           break;
//         default:
//           throw ApiException('Unsupported HTTP method: $method');
//       }

//       return _handleResponse<T>(response, fromJson);
//     } on SocketException {
//       throw ApiException('No internet connection');
//     } on TimeoutException {
//       throw ApiException('Request timeout. Please try again.');
//     } on HttpException {
//       throw ApiException('Network error occurred');
//     } on FormatException {
//       throw ApiException('Invalid response format');
//     } catch (e) {
//       if (e is ApiException) rethrow;
//       throw ApiException('Unexpected error: ${e.toString()}');
//     }
//   }

//   // Handle HTTP response
//   ApiResponse<T> _handleResponse<T>(
//       http.Response response,
//       T Function(dynamic)? fromJson,
//       ) {
//     try {
//       final dynamic responseData = jsonDecode(response.body);

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         // Success response
//         T? data;
//         if (fromJson != null && responseData != null) {
//           data = fromJson(responseData);
//         }

//         return ApiResponse<T>.success(
//           data: data,
//           message: _extractMessage(responseData),
//           statusCode: response.statusCode,
//           rawData: responseData,
//         );
//       } else {
//         // Error response
//         final errorMessage = _extractErrorMessage(responseData);

//         // Handle specific status codes
//         if (response.statusCode == 401) {
//           // Token expired or invalid
//           clearTokens(); // Clear tokens
//           throw UnauthorizedException(errorMessage);
//         }

//         return ApiResponse<T>.error(
//           message: errorMessage,
//           statusCode: response.statusCode,
//           rawData: responseData,
//         );
//       }
//     } catch (e) {
//       if (e is UnauthorizedException) rethrow;

//       // JSON parsing failed
//       return ApiResponse<T>.error(
//         message: 'Invalid response format',
//         statusCode: response.statusCode,
//         rawData: response.body,
//       );
//     }
//   }

//   // Extract success message from response
//   String _extractMessage(dynamic responseData) {
//     if (responseData is Map<String, dynamic>) {
//       return responseData['message'] ??
//           responseData['msg'] ??
//           'Success';
//     }
//     return 'Success';
//   }

//   // Extract error message from response
//   String _extractErrorMessage(dynamic responseData) {
//     if (responseData is Map<String, dynamic>) {
//       // Try different common error message keys
//       return responseData['message'] ??
//           responseData['error'] ??
//           responseData['msg'] ??
//           responseData['detail'] ??
//           'An error occurred';
//     } else if (responseData is String) {
//       return responseData;
//     }
//     return 'An error occurred';
//   }

//   // Public HTTP methods
//   Future<ApiResponse<T>> get<T>(
//       String endpoint, {
//         Map<String, String>? queryParams,
//         Map<String, String>? extraHeaders,
//         bool includeAuth = true,
//         T Function(dynamic)? fromJson,
//       }) async {
//     return _makeRequest<T>(
//       'GET',
//       endpoint,
//       queryParams: queryParams,
//       extraHeaders: extraHeaders,
//       includeAuth: includeAuth,
//       fromJson: fromJson,
//     );
//   }

//   Future<ApiResponse<T>> post<T>(
//       String endpoint, {
//         Map<String, dynamic>? body,
//         Map<String, String>? queryParams,
//         Map<String, String>? extraHeaders,
//         bool includeAuth = true,
//         T Function(dynamic)? fromJson,
//       }) async {
//     return _makeRequest<T>(
//       'POST',
//       endpoint,
//       body: body,
//       queryParams: queryParams,
//       extraHeaders: extraHeaders,
//       includeAuth: includeAuth,
//       fromJson: fromJson,
//     );
//   }

//   Future<ApiResponse<T>> put<T>(
//       String endpoint, {
//         Map<String, dynamic>? body,
//         Map<String, String>? queryParams,
//         Map<String, String>? extraHeaders,
//         bool includeAuth = true,
//         T Function(dynamic)? fromJson,
//       }) async {
//     return _makeRequest<T>(
//       'PUT',
//       endpoint,
//       body: body,
//       queryParams: queryParams,
//       extraHeaders: extraHeaders,
//       includeAuth: includeAuth,
//       fromJson: fromJson,
//     );
//   }

//   Future<ApiResponse<T>> patch<T>(
//       String endpoint, {
//         Map<String, dynamic>? body,
//         Map<String, String>? queryParams,
//         Map<String, String>? extraHeaders,
//         bool includeAuth = true,
//         T Function(dynamic)? fromJson,
//       }) async {
//     return _makeRequest<T>(
//       'PATCH',
//       endpoint,
//       body: body,
//       queryParams: queryParams,
//       extraHeaders: extraHeaders,
//       includeAuth: includeAuth,
//       fromJson: fromJson,
//     );
//   }

//   Future<ApiResponse<T>> delete<T>(
//       String endpoint, {
//         Map<String, String>? queryParams,
//         Map<String, String>? extraHeaders,
//         bool includeAuth = true,
//         T Function(dynamic)? fromJson,
//       }) async {
//     return _makeRequest<T>(
//       'DELETE',
//       endpoint,
//       queryParams: queryParams,
//       extraHeaders: extraHeaders,
//       includeAuth: includeAuth,
//       fromJson: fromJson,
//     );
//   }

//   // Token refresh method
//   Future<bool> refreshTokens() async {
//     try {
//       final refreshToken = await getRefreshToken();
//       if (refreshToken == null) return false;

//       final response = await post<Map<String, dynamic>>(
//         '/auth/refresh',
//         body: {'refreshToken': refreshToken},
//         includeAuth: false,
//       );

//       if (response.isSuccess && response.data != null) {
//         final newAccessToken = response.data!['accessToken'];
//         final newRefreshToken = response.data!['refreshToken'];

//         if (newAccessToken != null) {
//           await saveToken(newAccessToken);
//         }
//         if (newRefreshToken != null) {
//           await saveRefreshToken(newRefreshToken);
//         }

//         return true;
//       }

//       return false;
//     } catch (e) {
//       print('Token refresh failed: $e');
//       return false;
//     }
//   }
// }