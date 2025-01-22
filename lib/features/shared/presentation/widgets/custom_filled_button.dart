import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? buttonColor;
  final Icon? icon;
  final Color? textColor;
  final bool? isPosting;

  const CustomFilledButton({
    super.key,
    this.onPressed,
    required this.text,
    this.buttonColor,
    this.icon,
    this.textColor,
    this.isPosting = false,
  });

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(5);

    return FilledButton(
      style: FilledButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: Colors.grey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(radius)),
          minimumSize: const Size(100, 55)),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPosting!) ...[
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white, // Color del indicador de carga
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (icon != null && isPosting == false) ...[
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
