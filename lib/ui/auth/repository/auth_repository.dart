import 'package:grocery/models/result/auth_result.dart';
import 'package:grocery/models/user.dart';
import 'package:grocery/services/api_endpoints.dart';
import 'package:grocery/services/http_manager.dart';

class AuthRepository {
  final HttpManager httpManager = HttpManager();

  Future<AuthResult> validateToken(String token) async {
    final result = await httpManager.restRequest(
        url: ApiEndPoints.validate,
        method: HttpMethods.post,
        headers: {'X-Parse-Session-Token': token});

    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);
      return AuthResult.success(user);
    } else {
      return AuthResult.error(result['error']);
    }
  }

  Future<AuthResult> signIn(
      {required String email, required String password}) async {
    final result = await httpManager.restRequest(
        url: ApiEndPoints.login,
        method: HttpMethods.post,
        body: {"email": email, "password": password});

    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);

      return AuthResult.success(user);
    } else {
      return AuthResult.error(result['error']);
    }
  }

  Future<AuthResult> signUp(UserModel user) async {
    final result = await httpManager.restRequest(
        url: ApiEndPoints.register,
        method: HttpMethods.post,
        body: user.toJson());

    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);

      return AuthResult.success(user);
    } else {
      return AuthResult.error(result['error']);
    }
  }

  Future<void> resetPassword(String email) async {
    await httpManager.restRequest(
        url: ApiEndPoints.resetPassword,
        method: HttpMethods.post,
        body: {"email": email});
  }

  Future<bool> changePassword({required String email,
    required String currentPassword,
    required String newPassword,
    required String token}) async {
    final result = await httpManager.restRequest(
        url: ApiEndPoints.register,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token
        },
        body: {
          "email": email,
          "currentPassword": currentPassword,
          "newPassword": newPassword
        });

    return result['error'] == null;
  }

}
