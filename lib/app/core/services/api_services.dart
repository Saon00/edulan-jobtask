import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _timeout = Duration(seconds: 15);
  static final _storage = GetStorage();

  static const Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
  };

  // Get token from storage
  static String? get token => _storage.read('accessToken');

  // Build headers with token
  static Map<String, String> getHeaders({Map<String, String>? extraHeaders}) {
    final headers = Map<String, String>.from(_baseHeaders);
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  static Future<http.Response> get(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: getHeaders())
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw Exception("No internet connection");
    } on HttpException {
      throw Exception("Couldn't find the resource");
    } on FormatException {
      throw Exception("Bad response format");
    } on TimeoutException {
      throw Exception("Connection timeout");
    }
  }

  static Future<http.Response> post(String url, {dynamic body}) async {
    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: getHeaders(),
        body: jsonEncode(body),
      )
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> put(String url, {dynamic body}) async {
    try {
      final response = await http
          .put(
        Uri.parse(url),
        headers: getHeaders(),
        body: jsonEncode(body),
      )
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> delete(String url) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: getHeaders())
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Handle errors
  static http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception(
          'Error ${response.statusCode}: ${jsonDecode(response.body)['message'] ?? response.body}');
    }
  }

  // Save token
  static void saveToken(String token) {
    _storage.write('accessToken', token);
  }

  // Clear token (e.g. logout)
  static void clearToken() {
    _storage.remove('accessToken');
  }
}
