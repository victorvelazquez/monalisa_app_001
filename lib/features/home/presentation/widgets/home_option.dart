import 'package:flutter/material.dart';

import '../../../../config/config.dart';

class HomeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const HomeOption({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        // elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(themeBorderRadius)),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(themeBorderRadius),
            color: themeColorPrimary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 34, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: themeFontSizeSmall, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
