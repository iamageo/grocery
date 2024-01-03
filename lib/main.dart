import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:grocery/app_colors.dart';
import 'package:grocery/routes/app_screen_names.dart';
import 'package:grocery/routes/app_screens.dart';
import 'package:grocery/ui/auth/controller/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App Example',
      theme: ThemeData(
        primarySwatch: CustomColors.customSwatchColor,
        useMaterial3: false
      ),
      initialRoute: AppScreensNames.splash,
      getPages: AppScreens.pages,
      onInit: () {
        Get.put<AuthController>(AuthController(), permanent: true,);
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
