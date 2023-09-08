import 'package:flutter/material.dart';
import 'package:grocery/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final bool isSelected;
  final String category;
  final VoidCallback onPress;

  const CategoryItem(
      {super.key, required this.isSelected, required this.category, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: isSelected ? BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(18)
        ) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Text(category, style: TextStyle(color: isSelected ? Colors.white : CustomColors.customContrastColor,)),
        ),
      ),
    );
  }
}
