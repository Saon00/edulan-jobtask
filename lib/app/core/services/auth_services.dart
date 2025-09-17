// lib/services/auth_service.dart


import 'package:eduline/app/core/networks/urls.dart';
import 'package:eduline/app/core/services/api_services.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        URLs.loginUrl, // Change this endpoint as needed
        body: {
          'email': email,
          'password': password,
        },
        includeAuth: false,
      );

      if (response['success']) {
        final data = response['data'];

        // Extract token from your API response structure
        // Adjust these keys based on your API response
        final accessToken = data['data']?['accessToken'] ??
            data['accessToken'] ??
            data['access_token'] ??
            data['token'];

        final refreshToken = data['data']?['refreshToken'] ??
            data['refreshToken'] ??
            data['refresh_token'];

        // Save tokens
        if (accessToken != null) {
          await _apiService.saveToken(accessToken);
        }
        if (refreshToken != null) {
          await _apiService.saveRefreshToken(refreshToken);
        }
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Login failed: ${e.toString()}',
      };
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'password': password,
      };

      if (phone != null) body['phone'] = phone;
      if (additionalFields != null) {
        additionalFields.forEach((key, value) {
          body[key] = value;
        });
      }

      final response = await _apiService.post(
        '/auth/register', // Change this endpoint as needed
        body: body,
        includeAuth: false,
      );

      if (response['success']) {
        final data = response['data'];

        // Extract tokens (adjust keys based on your API)
        final accessToken = data['data']?['accessToken'] ??
            data['accessToken'] ??
            data['access_token'] ??
            data['token'];

        final refreshToken = data['data']?['refreshToken'] ??
            data['refreshToken'] ??
            data['refresh_token'];

        // Save tokens if available
        if (accessToken != null) {
          await _apiService.saveToken(accessToken);
        }
        if (refreshToken != null) {
          await _apiService.saveRefreshToken(refreshToken);
        }
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Registration failed: ${e.toString()}',
      };
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      // Optional: Call logout endpoint
      final response = await _apiService.post('/auth/logout');

      // Always clear local tokens
      await _apiService.clearTokens();

      return {
        'success': true,
        'message': 'Logged out successfully',
      };
    } catch (e) {
      // Even if API call fails, clear local tokens
      await _apiService.clearTokens();
      return {
        'success': true,
        'message': 'Logged out successfully',
      };
    }
  }

  // Forgot Password
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _apiService.post(
        URLs.forgotPassword, // Change this endpoint as needed
        body: {'email': email},
        includeAuth: false,
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to send reset email: ${e.toString()}',
      };
    }
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
    String? confirmPassword,
    String? email, // Add email parameter
  }) async {
    try {
      final body = {
        'token': token,
        'password': newPassword,
      };

      if (confirmPassword != null) {
        body['confirmPassword'] = confirmPassword;
      }

      // Add email if provided (some APIs require it)
      if (email != null) {
        body['email'] = email;
      }

      final response = await _apiService.post(
       URLs.resetPassword, // Fixed: was using wrong endpoint (URLs.verifyOTP)
        body: body,
        includeAuth: false,
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Password reset failed: ${e.toString()}',
      };
    }
  }

  // Change Password (for logged-in users)
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    String? confirmPassword,
  }) async {
    try {
      final body = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };

      if (confirmPassword != null) {
        body['confirmPassword'] = confirmPassword;
      }

      final response = await _apiService.put(
        URLs.changePassword, // Change this endpoint as needed
        body: body,
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Password change failed: ${e.toString()}',
      };
    }
  }

  // Get User Profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiService.get('/user/profile'); // Change endpoint as needed

      // Handle token refresh if needed
      if (!response['success'] && response['statusCode'] == 401) {
        final refreshed = await _apiService.refreshToken();
        if (refreshed) {
          // Retry the request
          return await _apiService.get('/user/profile');
        }
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to get user profile: ${e.toString()}',
      };
    }
  }

  // Update User Profile
  Future<Map<String, dynamic>> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;
      if (phone != null) body['phone'] = phone;
      if (additionalFields != null) {
        additionalFields.forEach((key, value) {
          body[key] = value;
        });
      }

      final response = await _apiService.put(
        '/user/profile', // Change this endpoint as needed
        body: body,
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Profile update failed: ${e.toString()}',
      };
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiService.post(
        URLs.verifyOTP, // Change this endpoint as needed
        body: {
          'email': email,
          'otp': otp,
        },
        includeAuth: false,
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'OTP verification failed: ${e.toString()}',
      };
    }
  }

  // Verify Email
  Future<Map<String, dynamic>> verifyEmail({
    required String code,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/verify-email', // Change this endpoint as needed
        body: {'code': code},
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Email verification failed: ${e.toString()}',
      };
    }
  }

  // Resend Verification Email
  Future<Map<String, dynamic>> resendVerificationEmail() async {
    try {
      final response = await _apiService.post('/auth/resend-verification');
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to resend verification email: ${e.toString()}',
      };
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _apiService.isLoggedIn();
  }

  // Refresh token
  Future<bool> refreshToken() async {
    return await _apiService.refreshToken();
  }

  // Social Login (Google, Facebook, etc.)
  Future<Map<String, dynamic>> socialLogin({
    required String provider, // 'google', 'facebook', 'apple', etc.
    required String token,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final body = {
        'provider': provider,
        'token': token,
      };

      if (additionalData != null) {
        additionalData.forEach((key, value) {
          body[key] = value;
        });
      }

      final response = await _apiService.post(
        '/auth/social-login', // Change this endpoint as needed
        body: body,
        includeAuth: false,
      );

      if (response['success']) {
        final data = response['data'];

        // Extract and save tokens
        final accessToken = data['data']?['accessToken'] ??
            data['accessToken'] ??
            data['access_token'] ??
            data['token'];

        final refreshToken = data['data']?['refreshToken'] ??
            data['refreshToken'] ??
            data['refresh_token'];

        if (accessToken != null) {
          await _apiService.saveToken(accessToken);
        }
        if (refreshToken != null) {
          await _apiService.saveRefreshToken(refreshToken);
        }
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Social login failed: ${e.toString()}',
      };
    }
  }

  // Delete Account
  Future<Map<String, dynamic>> deleteAccount({
    required String password,
  }) async {
    try {
      final response = await _apiService.delete(
        '/user/account', // Change this endpoint as needed
        queryParams: {'password': password},
      );

      if (response['success']) {
        await _apiService.clearTokens();
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Account deletion failed: ${e.toString()}',
      };
    }
  }
}