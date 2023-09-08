import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../utils/validators.dart';
import '../../auth/controller/auth_controller.dart';
import '../../components/custom_text_field.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {

  final authController = Get.find<AuthController>();

  final cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});

  final phoneFormatter = MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {'#': RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Perfil",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                authController.signOut();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          physics: const BouncingScrollPhysics(),
          children: [
            CustomTextField(
              readOnly: true,
              initialValue: authController.user.fullname,
              icon: Icons.person,
              label: "Nome",
              isSecret: false,
              validator: (name) {
                if (name!.isEmpty) return "Digite seu nome";
                final names = name.split(" ");

                if (names.length == 1) {
                  return ("Digite seu nome completo!");
                }
                return null;
              },
            ),
            CustomTextField(
              readOnly: true,
              initialValue: authController.user.email,
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
              readOnly: true,
              initialValue: authController.user.phone,
              icon: Icons.phone,
              label: "Celular",
              isSecret: false,
              validator: (number) {
                if (number!.isEmpty) {
                  return "Digite seu número de celular";
                }
                return null;
              },
            ),
            CustomTextField(
              readOnly: true,
              initialValue: authController.user.cpf,
              icon: Icons.perm_identity,
              label: "CPF",
              isSecret: true,
              validator: (cpf) {
                if (cpf!.isEmpty) return "Digite seu CPF";
                if (cpf.isCpf) return "Digite um cpf válido";
                return null;
              },
            ),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18))),
                  onPressed: () async {
                    bool? result = await showDialogConfirmation();
                    print(result);
                  },
                  child: const Text(
                    "Atualizar senha",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<bool?> showDialogConfirmation() {

    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Atualizar senha",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    CustomTextField(
                      controller: currentPasswordController,
                      icon: Icons.lock,
                      label: "Senha atual",
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
                      controller: newPasswordController,
                      icon: Icons.lock,
                      label: "Nova senha",
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
                      icon: Icons.lock,
                      label: "Confirmar nova senha",
                      isSecret: true,
                      validator: (password) {
                        final result = passwordValidator(password);

                        if (result != null) {
                          return result;
                        }

                        if (password != newPasswordController.text) {
                          return 'As senhas não são equivalentes';
                        }

                        return null;
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text(
                        "Atualizar",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: - 5,
                    right: -5,
                    child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: const Icon(Icons.close),
                ))
              ],
            ),
          );
        });
  }
}
