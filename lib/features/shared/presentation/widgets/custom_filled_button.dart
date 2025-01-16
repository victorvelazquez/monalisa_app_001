import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? buttonColor;
  final Icon? icon;
  final Color? textColor;

  const CustomFilledButton(
      {super.key,
      this.onPressed,
      required this.text,
      this.buttonColor,
      this.icon,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(5);

    return FilledButton(
      style: FilledButton.styleFrom(
          backgroundColor: buttonColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(radius)),
          minimumSize: const Size(100, 55)),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon!.icon,
              color: textColor ?? Colors.white,
              size: 22,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(color: textColor ?? Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
