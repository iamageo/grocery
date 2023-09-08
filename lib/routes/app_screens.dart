import 'package:get/get.dart';
import 'package:grocery/routes/app_screen_names.dart';
import 'package:grocery/ui/auth/sign_in_screen.dart';
import 'package:grocery/ui/auth/sign_up_screen.dart';
import 'package:grocery/ui/pages/orders/binding/order_binding.dart';
import 'package:grocery/ui/pages/splash/splash_screen.dart';

import '../ui/pages/base/base_screen.dart';
import '../ui/pages/base/binding/navigation_binding.dart';
import '../ui/pages/cart/binding/cart_binding.dart';
import '../ui/pages/home/binding/home_binding.dart';
import '../ui/pages/product/product_sreen.dart';

abstract class AppScreens {
  static final pages = <GetPage>[
    GetPage(name: AppScreensNames.splash, page: () => SplashScreen()),
    GetPage(name: AppScreensNames.login, page: () => SignInScreen()),
    GetPage(name: AppScreensNames.register, page: () => const SignUpScreen()),
    GetPage(
        name: AppScreensNames.home,
        page: () => const BaseScreen(),
        bindings: [HomeBinding(), NavigationBinding(), CartBinding(), OrderBinding()]),
    GetPage(
        name: AppScreensNames.product,
        page: () => ProductScreen(item: Get.arguments['item'])),
  ];
}
