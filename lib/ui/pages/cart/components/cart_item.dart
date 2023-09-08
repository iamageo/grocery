import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grocery/app_colors.dart';
import 'package:grocery/models/cart_item_model.dart';
import 'package:grocery/ui/components/quantity_item.dart';
import 'package:grocery/ui/pages/cart/controller/cart_controller.dart';
import 'package:grocery/utils/services.dart';

class CartItem extends StatefulWidget {
  final CartItemModel item;
  const CartItem({super.key, required this.item});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  Services services = Services();
  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Image.network(
          widget.item.item.imgUrl,
          height: 60,
          width: 60,
        ),
        title: Text(
          widget.item.item.itemName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          services.priceToCurrency(widget.item.totalPrice()),
          style: TextStyle(color: CustomColors.customSwatchColor),
        ),
        trailing: QuantityItem(
          value: widget.item.quantity,
          suffixText: widget.item.item.unit,
          result: (int quantity) {
            controller.changeItemQuantity(item: widget.item, quantity: quantity);
          },
          isRemovable: true,
        ),
      ),
    );
  }
}
