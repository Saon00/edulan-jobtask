// // lib/services/auth_service.dart
// import 'package:eduline/app/core/networks/urls.dart';
// import 'package:eduline/app/core/services/api_services.dart';

// import '../models/login_response_model.dart';
// class AuthService {
//   final ApiService _apiService = ApiService();

//   // Login method
//   Future<ApiResponse<LoginResponse>> login(String email, String password) async {
//     try {
//       final response = await _apiService.post<LoginResponse>(
//         URLs.loginUrl,
//         body: {
//           "email": email,
//           "password": password,
//         },
//         includeAuth: false, // No auth needed for login
//         fromJson: (json) => LoginResponse.fromJson(json),
//       );

//       if (response.isSuccess && response.data != null) {
//         final loginData = response.data!;

//         // Save tokens if login is successful
//         if (loginData.success && loginData.data != null) {
//           await _apiService.saveToken(loginData.data!.accessToken);

//           // Save refresh token if available
//           if (loginData.data!.refreshToken != null) {
//             await _apiService.saveRefreshToken(loginData.data!.refreshToken!);
//           }
//         }
//       }

//       return response;
//     } catch (e) {
//       if (e is ApiException) {
//         return ApiResponse<LoginResponse>.error(message: e.message);
//       }
//       return ApiResponse<LoginResponse>.error(
//         message: 'Login failed: ${e.toString()}',
//       );
//     }
//   }

//   // Register method
//   Future<ApiResponse<LoginResponse>> register({
//     required String name,
//     required String email,
//     required String password,
//     String? phone,
//   }) async {
//     try {
//       final body = {
//         "name": name,
//         "email": email,
//         "password": password,
//       };

//       if (phone != null) {
//         body["phone"] = phone;
//       }

//       final response = await _apiService.post<LoginResponse>(
//         URLs.registerUrl,
//         body: body,
//         includeAuth: false,
//         fromJson: (json) => LoginResponse.fromJson(json),
//       );

//       if (response.isSuccess && response.data != null) {
//         final registerData = response.data!;

//         // Save tokens if registration is successful
//         if (registerData.success && registerData.data != null) {
//           await _apiService.saveToken(registerData.data!.accessToken);

//           if (registerData.data!.refreshToken != null) {
//             await _apiService.saveRefreshToken(registerData.data!.refreshToken!);
//           }
//         }
//       }

//       return response;
//     } catch (e) {
//       if (e is ApiException) {
//         return ApiResponse<LoginResponse>.error(message: e.message);
//       }
//       return ApiResponse<LoginResponse>.error(
//         message: 'Registration failed: ${e.toString()}',
//       );
//     }
//   }

//   // Forgot password
//   Future<ApiResponse<Map<String, dynamic>>> forgotPassword(String email) async {
//     try {
//       final response = await _apiService.post<Map<String, dynamic>>(
//         URLs.forgotPasswordUrl,
//         body: {"email": email},
//         includeAuth: false,
//         fromJson: (json) => json as Map<String, dynamic>,
//       );

//       return response;
//     } catch (e) {
//       if (e is ApiException) {
//         return ApiResponse<Map<String, dynamic>>.error(message: e.message);
//       }
//       return ApiResponse<Map<String, dynamic>>.error(
//         message: 'Failed to send reset email: ${e.toString()}',
//       );
//     }
//   }

//   // Reset password
//   Future<ApiResponse<Map<String, dynamic>>> resetPassword({
//     required String token,
//     required String newPassword,
//   }) async {
//     try {
//       final response = await _apiService.post<Map<String, dynamic>>(
//         URLs.resetPasswordUrl,
//         body: {
//           "token": token,
//           "password": newPassword,
//         },
//         includeAuth: false,
//         fromJson: (json) => json as Map<String, dynamic>,
//       );

//       return response;
//     } catch (e) {
//       if (e is ApiException) {
//         return ApiResponse<Map<String, dynamic>>.error(message: e.message);
//       }
//       return ApiResponse<Map<String, dynamic>>.error(
//         message: 'Password reset failed: ${e.toString()}',
//       );
//     }
//   }

//   // Change password (for logged-in users)
//   Future<ApiResponse<Map<String, dynamic>>> changePassword({
//     required String currentPassword,
//     required String newPassword,
//   }) async {
//     try {
//       final response = await _apiService.put<Map<String, dynamic>>(
//         URLs.changePasswordUrl,
//         body: {
//           "currentPassword": currentPassword,
//           "newPassword": newPassword,
//         },
//         fromJson: (json) => json as Map<String, dynamic>,
//       );

//       return response;
//     } catch (e) {
//       if (e is ApiException) {
//         return ApiResponse<Map<String, dynamic>>.error(message: e.message);
//       }
//       return ApiResponse<Map<String, dynamic>>.error(
//         message: 'Password change failed: ${e.toString()}',
//       );
//     }
//   }

//   // Get current user profile
//   Future<ApiResponse<Map<String, dynamic>>> getUserProfile() async {
//     try {
//       final response = await _apiService.get<Map<String, dynamic>>(
//         URLs.userProfileUrl,
//         fromJson: (json) => json as Map<String, dynamic>,
//       );

//       return response;
//     } catch (e) {
//       if (e is UnauthorizedException) {
//         // Token expired, try to refresh
//         final refreshSuccess = await _apiService.refreshTokens();
//         if (refreshSuccess) {
//           // Retry the request
//           return getUserProfile();
//         }
//       }

//       if (e is ApiException) {
//         return ApiResponse<Map<String, dynamic>>.error(message: e.message);
//       }
//       return ApiResponse<Map<String, dynamic>>.error(
//         message: 'Failed to get user profile: ${e.toString()}',
//       );
//     }
//   }

//   // Update user profile
//   Future<ApiResponse<Map<String, dynamic>>> updateUserProfile({
//     String? name,
//     String? email,
//     String? phone,
//   }) async {
//     try {
//       final body = <String, dynamic>{};
//       if (name != null) body['name'] = name;
//       if (email != null) body['email'] = email;
//       if (phone != null) body['phone'] = phone;

//       final response = await _apiService.put<Map<String, dynamic>>(
//         URLs.updateProfileUrl,
//         body: body,
//         fromJson: (json) => json as Map<String, dynamic>,
//       );

//       return response;
//     } catch (e) {
//       if (e is ApiException) {
//         return ApiResponse<Map<String, dynamic>>.error(message: e.message);
//       }
//       return ApiResponse<Map<String, dynamic>>.error(
//         message: 'Profile update failed: ${e.toString()}',
//       );
//     }
//   }

//   // Logout
//   Future<ApiResponse<Map<String, dynamic>>> logout() async {
//     try {
//       // Call logout endpoint (optional)
//       final response = await _apiService.post<Map<String, dynamic>>(
//         URLs.logoutUrl,
//         fromJson: (json) => json as Map<String, dynamic>,
//       );

//       // Clear tokens regardless of API response
//       await _apiService.clearTokens();

//       return response;
//     } catch (e) {
//       // Even if API call fails, clear local tokens
//       await _apiService.clearTokens();

//       return ApiResponse<Map<String, dynamic>>.success(
//         message: 'Logged out successfully',
//       );
//     }
//   }

//   // Check if user is logged in
//   Future<bool> isLoggedIn() async {
//     return await _apiService.isLoggedIn();
//   }

//   // Refresh token
//   Future<bool> refreshToken() async {
//     return await _apiService.refreshTokens();
//   }

//   // Verify email (if your app has email verification)
//   Future<ApiResponse<Map<String, dynamic>>> verifyEmail(String code) async {
//     try {
//       final response = await _apiService.post<Map<String, dynamic>>(
//         URLs.verifyEmailUrl,
//         body: {"code": code},
//         fromJson: (json) => json as Map<String, dynamic>,
//       );

//       return response;
//     } catch (e) {
//       if (e is ApiException) {
//         return ApiResponse<Map<String, dynamic>>.error(message: e.message);
//       }
//       return ApiResponse<Map<String, dynamic>>.error(
//         message: 'Email verification failed: ${e.toString()}',
//       );
//     }
//   }

//   // Resend verification email
//   Future<ApiResponse<Map<String, dynamic>>> resendVerificationEmail() async {
//     try {
//       final response = await _apiService.post<Map<String, dynamic>>(
//         URLs.resendVerificationUrl,
//         fromJson: (json) => json as Map<String, dynamic>,
//       );

//       return response;
//     } catch (e) {
//       if (e is ApiException) {
//         return ApiResponse<Map<String, dynamic>>.error(message: e.message);
//       }
//       return ApiResponse<Map<String, dynamic>>.error(
//         message: 'Failed to resend verification email: ${e.toString()}',
//       );
//     }
//   }
// }