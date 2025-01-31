import 'package:flutter/material.dart';

class BnqtButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon; // Optional icon
  final double fontSize;
  final double verticalPadding;
  final Color backgroundColor;
  final Color textColor;
  final BorderRadiusGeometry borderRadius;

  const BnqtButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.fontSize = 18,
    this.verticalPadding = 16.0,
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        icon: icon != null
            ? Icon(
                icon,
                color: textColor,
              )
            : const SizedBox.shrink(), // Empty space if no icon
        label: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: textColor),
        ),
      ),
    );
  }
}
