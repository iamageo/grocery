import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grocery/app_colors.dart';
import 'package:grocery/models/item_model.dart';
import 'package:grocery/ui/pages/cart/controller/cart_controller.dart';
import 'package:grocery/utils/services.dart';

class GridItem extends StatefulWidget {
  final ItemModel item;
  final void Function(GlobalKey) cartAnimationMethod;

  const GridItem({super.key, required this.item, required this.cartAnimationMethod});

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {

  final GlobalKey imageGk = GlobalKey();
  final Services services = Services();
  final cartController = Get.find<CartController>();

  IconData tileIcon = Icons.add_shopping_cart_outlined;

  Future<void> switchIcon() async {
    setState(() => tileIcon = Icons.check);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => tileIcon = Icons.add_shopping_cart_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          Get.toNamed("/product", arguments: {'item': widget.item});
        },
        child: Card(
          elevation: 1,
          shadowColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: Hero(tag: widget.item.imgUrl, child: Image.network(widget.item.imgUrl, key: imageGk,))),
                Text(
                  widget.item.itemName,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      services.priceToCurrency(widget.item.price),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.customSwatchColor),
                    ),
                    Text(
                      " /${widget.item.unit}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),

      Positioned(
        top: 4,
        right: 4,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            topRight: Radius.circular(20),
          ),
          child: Material(
            child: InkWell(
              onTap: () {
                switchIcon();
                cartController.addItemToCart(item: widget.item);
                widget.cartAnimationMethod(imageGk);
              },
              child: Ink(
                height: 40,
                width: 35,
                decoration: BoxDecoration(
                  color: CustomColors.customSwatchColor,
                ),
                child: Icon(
                  tileIcon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
