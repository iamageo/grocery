import 'package:get/get.dart';
import 'package:grocery/constants.dart';
import 'package:grocery/models/result/auth_result.dart';
import 'package:grocery/models/user.dart';
import 'package:grocery/routes/app_screen_names.dart';
import 'package:grocery/utils/services.dart';

import '../repository/auth_repository.dart';

class AuthController extends GetxController {
  final authRepository = AuthRepository();
  UserModel user = UserModel();
  Services services = Services();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      validateToken();
    });
  }

  Future<void> validateToken() async {
    String? token = await services.getLocalData(key: StorageKeys.token);

    if (token == null) {
      Get.offAllNamed(AppScreensNames.login);
      return;
    }

    AuthResult result = await authRepository.validateToken(token);

    result.when(success: (user) {
      this.user = user;
      saveDataAndProceedToHome();
    }, error: (e) {
      signOut();
    });
  }

  Future<void> signOut() async {
    user = UserModel();
    await services.deleteLocalData(key: StorageKeys.token);
    Get.offAllNamed(AppScreensNames.login);
  }

  void saveDataAndProceedToHome() {
    services.saveLocalData(key: StorageKeys.token, data: user.token!);
    Get.offAllNamed(AppScreensNames.home);
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;
    AuthResult result =
        await authRepository.signIn(email: email, password: password);
    isLoading.value = false;

    result.when(success: (user) {
      this.user = user;
      saveDataAndProceedToHome();
    }, error: (error) {
      services.showToast(
          message: "Ocorreu um erro ao realizar login.", isError: true);
    });
  }

  Future<void> signUp(UserModel user) async {
    isLoading.value = true;

    AuthResult result = await authRepository.signUp(user);

    isLoading.value = false;

    result.when(success: (user) {
      this.user = user;
      saveDataAndProceedToHome();
    }, error: (error) {
      services.showToast(
          message: "Ocorreu um erro ao realizar cadastro. $error",
          isError: true);
    });
  }

  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    isLoading.value = true;
    final result = await authRepository.changePassword(
        email: user.email!,
        currentPassword: currentPassword,
        newPassword: newPassword,
        token: user.token!);

    isLoading.value = false;

    if (result) {
      services.showToast(
          message: "A senha foi atualizada com sucesso!", isError: false);
      signOut();
    } else {
      services.showToast(
          message: "A senha atual informada esta incorreta.", isError: true);
    }
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }
}
