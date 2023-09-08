import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:grocery/app_colors.dart';
import 'package:grocery/models/item_model.dart';
import 'package:grocery/ui/components/quantity_item.dart';
import 'package:grocery/ui/pages/base/controller/navigation_controller.dart';
import 'package:grocery/utils/services.dart';

import '../cart/controller/cart_controller.dart';

class ProductScreen extends StatefulWidget {
  final ItemModel item;

  const ProductScreen({super.key, required this.item});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int cardItemQuantity = 1;

  final cartController = Get.find<CartController>();
  final navigationController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    Services services = Services();

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
                child: Hero(tag: widget.item.imgUrl, child: Image.network(widget.item.imgUrl))),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(60)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade600,
                          offset: const Offset(0, 2))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.itemName,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        QuantityItem(
                          value: cardItemQuantity,
                          suffixText: widget.item.unit,
                          result: (quantity) {
                            setState(() {
                              cardItemQuantity = quantity;
                            });
                          },
                        )
                      ],
                    ),
                    Text(
                      services.priceToCurrency(widget.item.price),
                      style: TextStyle(
                          color: CustomColors.customSwatchColor,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SingleChildScrollView(
                          child: Text(
                            widget.item.description,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () {
                            Get.back();

                            cartController.addItemToCart(
                              item: widget.item,
                              quantity: cardItemQuantity,
                            );

                            navigationController.navigatePageView(NavigationTabs.cart);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        label: const Text(
                          "Adicionar no carrinho",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )
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
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios))),
        )
      ]),
    );
  }
}
