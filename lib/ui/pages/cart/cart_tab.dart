import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/app_colors.dart';
import 'package:grocery/models/cart_item_model.dart';
import 'package:grocery/ui/pages/cart/controller/cart_controller.dart';
import 'package:grocery/utils/app_data.dart';
import 'package:grocery/utils/services.dart';

import 'components/cart_item.dart';

class CartTab extends StatefulWidget {
  CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  Services services = Services();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Carrinho",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: GetBuilder<CartController>(
            builder: (controller) {
              if (controller.cartItems.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart,
                      size: 40,
                      color: CustomColors.customSwatchColor,
                    ),
                    const Text('Não há itens no carrinho'),
                  ],
                );
              }

              return ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  return CartItem(item: controller.cartItems[index]);
                },
              );
            },
          )),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3,
                      spreadRadius: 2)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Valor total",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  GetBuilder<CartController>(
                    builder: (controller) {
                      return Text(
                        services.priceToCurrency(controller.cartTotalPrice()),
                        style: TextStyle(
                          fontSize: 23,
                          color: CustomColors.customSwatchColor,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                    child: GetBuilder<CartController>(
                      builder: (controller) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: CustomColors.customSwatchColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: (controller.isCheckoutLoading ||
                                  controller.cartItems.isEmpty)
                              ? null
                              : () async {
                                  bool? result = await showDialogConfirmation();

                                  if (result ?? false) {
                                    cartController.checkoutCart();
                                  } else {
                                    services.showToast(
                                        message: 'Pedido não confirmado',
                                        isError: true);
                                  }
                                },
                          child: controller.isCheckoutLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Concluir pedido',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> showDialogConfirmation() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Confirmar"),
            content: const Text("Deseja realmente concluir o pedido?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Nao"),
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
                  "Sim",
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }
}
