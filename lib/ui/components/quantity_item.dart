import 'package:flutter/material.dart';
import 'package:grocery/app_colors.dart';

class QuantityItem extends StatelessWidget {
  final int value;
  final String suffixText;
  final Function(int quantiry) result;
  final bool isRemovable;

  const QuantityItem(
      {super.key,
      required this.value,
      required this.suffixText,
      required this.result,
      this.isRemovable = false
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 2)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            color: !isRemovable || value > 1 ? Colors.grey : Colors.red,
            icon: !isRemovable || value > 1 ? Icons.remove : Icons.delete_forever,
            onPress: () {
              if(value == 1 && !isRemovable) return;

              int resultCount = value - 1;
              result(resultCount);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text("$value $suffixText",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          _QuantityButton(
              color: CustomColors.customSwatchColor,
              icon: Icons.add,
              onPress: () {
                int resultCount = value + 1;
                result(resultCount);
              }),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onPress;

  const _QuantityButton(
      {Key? key,
      required this.color,
      required this.icon,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          onPress();
        },
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
    );
  }
}
