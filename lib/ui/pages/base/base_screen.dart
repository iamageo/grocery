import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/app_colors.dart';
import '../cart/cart_tab.dart';
import '../home/home_tab.dart';
import '../orders/orders_tab.dart';
import '../profile/profile_tab.dart';
import 'controller/navigation_controller.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final navigationController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: navigationController.pageController,
          children: [
            const HomeTab(),
            CartTab(),
            const OrdersTab(),
            const ProfileTab()
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: navigationController.currentIndex,
            onTap: (index) {
              navigationController.navigatePageView(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withAlpha(100),
            backgroundColor: CustomColors.customSwatchColor,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  label: "Carrinho"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list_alt,
                    color: Colors.white,
                  ),
                  label: "Pedidos"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  label: "Perfil")
            ],
          ),
        ));
  }
}
