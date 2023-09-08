import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/app_colors.dart';
import 'package:grocery/routes/app_screen_names.dart';
import 'package:grocery/ui/auth/controller/auth_controller.dart';
import 'package:grocery/ui/auth/forgot_password_dialog.dart';
import 'package:grocery/ui/components/custom_text_field.dart';
import 'package:grocery/utils/services.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Services services = Services();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Lottie.asset("lib/assets/animation.json", height: 200)),
                      const Text(
                        "Grocery App",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        controller: emailController,
                        icon: Icons.email,
                        label: "E-mail",
                        isSecret: false,
                        validator: (email) {
                          if (email == null || email.isEmpty)
                            return "Digite seu e-mail";
                          if (!email.isEmail) return "Digite um e-mail válido";
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: passwordController,
                        icon: Icons.lock,
                        label: "Password",
                        isSecret: true,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return "Digite sua senha";
                          }
                          if (password.length < 7) {
                            return "Digite uma senha com pelo menos 7 caracteres.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                          height: 50,
                          child: GetX<AuthController>(
                            builder: (controller) {
                              return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18))),
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            controller.signIn(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text);
                                          } else {
                                            print("campos nao validos");
                                          }
                                        },
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "Entrar",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ));
                            },
                          )),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () async {
                                final result = await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return ForgotPasswordDialog(
                                          email: emailController.text);
                                    });

                                if (result ?? false) {
                                  services.showToast(
                                      message: "E-mail enviado com sucesso!",
                                      isError: false);
                                }
                              },
                              child: Text(
                                "Esqueceu a senha?",
                                style: TextStyle(
                                    color: CustomColors.customContrastColor),
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Divider(
                            color: Colors.grey[200],
                            thickness: 2,
                          )),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("Ou"),
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.grey[200],
                            thickness: 2,
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                    color: CustomColors.customSwatchColor,
                                    width: 2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18))),
                            onPressed: () {
                              Get.toNamed(AppScreensNames.register);
                            },
                            child: const Text("Criar conta")),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
