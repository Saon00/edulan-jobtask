import 'dart:convert';
import 'package:eduline/app/core/models/login_response_model.dart';
import 'package:eduline/app/core/networks/urls.dart';
import 'api_services.dart';

class AuthService {
  Future<LoginResponse> login(String email, String password) async {
    final response = await ApiService.post(
      URLs.loginUrl,
      body: {
        "email": email,
        "password": password,
      },
    );

    final data = jsonDecode(response.body);
    final loginData = LoginResponse.fromJson(data);

    if (loginData.success && loginData.data != null) {
      ApiService.saveToken(loginData.data!.accessToken); // Save token
    }

    return loginData;
  }
}
