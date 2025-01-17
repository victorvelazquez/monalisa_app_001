import 'package:flutter/material.dart';

class TemplateCustomButton extends StatelessWidget {
  const TemplateCustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: colors.primary,
        child: InkWell(
          onTap: (){},
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text('Personalizado', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
