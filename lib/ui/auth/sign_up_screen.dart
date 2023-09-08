import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grocery/models/user.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../app_colors.dart';
import '../components/custom_text_field.dart';
import 'controller/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});

  final phoneFormatter = MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {'#': RegExp(r'[0-9]')});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cpfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 90.0),
                    child: Container(
                      height: 50,
                      color: CustomColors.customSwatchColor,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Cadastro",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                          textInputType: TextInputType.emailAddress,
                          controller: emailController,
                          icon: Icons.email,
                          label: "E-mail",
                          isSecret: false,
                          validator: (email) {
                            if (email!.isEmpty) return "Digite seu e-mail";
                            if (!email.isEmail) {
                              return "informe um e-mail válido";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: passwordController,
                          icon: Icons.lock,
                          label: "Password",
                          isSecret: true,
                          validator: (password) {
                            if (password!.isEmpty) return "Digite sua senha";
                            if (password.length < 7) {
                              return "Senha informada muito curta.";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: nameController,
                          icon: Icons.person,
                          label: "Nome",
                          isSecret: false,
                          validator: (name) {
                            if (name!.isEmpty) return "Digite seu nome";
                            final names = name.split(" ");

                            if (names.length == 1)
                              return ("Digite seu nome completo!");
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: phoneController,
                          icon: Icons.phone,
                          label: "Celular",
                          isSecret: false,
                          textInputType: TextInputType.number,
                          validator: (number) {
                            if (number!.isEmpty)
                              return "Digite seu número de celular";
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: cpfController,
                          icon: Icons.perm_identity,
                          textInputType: TextInputType.number,
                          label: "CPF",
                          isSecret: false,
                          validator: (cpf) {
                            if (cpf!.isEmpty) return "Digite seu CPF";
                            if (cpf.isCpf) return "Digite um cpf válido";
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
                                              controller.signUp(UserModel(
                                                  fullname: nameController.text,
                                                  password: passwordController.text,
                                                  email: emailController.text,
                                                  phone: phoneController.text,
                                                  cpf: cpfController.text));
                                            } else {
                                              print("campos nao validos");
                                            }
                                          },
                                    child: controller.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text(
                                            "Cadastrar usuário",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ));
                              },
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              left: 10,
              top: 10,
              child: SafeArea(
                  child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              )),
            )
          ]),
        ),
      ),
    );
  }
}
