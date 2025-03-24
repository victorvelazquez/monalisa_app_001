import 'package:flutter/material.dart';

import 'custom_filled_button.dart';

class ContainerActionButtons extends StatelessWidget {
  final List<CustomFilledButton> children;
  final bool center;

  const ContainerActionButtons({
    super.key, 
    required this.children,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      alignment: center ? WrapAlignment.center : WrapAlignment.end,
      children: children,
    );
  }
}
