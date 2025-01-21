import 'package:flutter/material.dart';
import 'package:monalisa_app_001/config/config.dart';

class EnterBarcodeBox extends StatelessWidget {
  final ValueChanged<String> onValue;
  const EnterBarcodeBox({
    super.key,
    required this.onValue,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final focusNode = FocusNode();
    final outlineInputBorder = UnderlineInputBorder(
        borderSide: BorderSide(color: colorSeed),
        borderRadius: BorderRadius.circular(10));
    final inputDecoration = InputDecoration(
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        fillColor: Colors.white,
        filled: true,
        suffixIcon: IconButton(
            icon: Icon(Icons.send_rounded),
            color: colorSeed,
            onPressed: () {
              focusNode.requestFocus();
              final textValue = textController.value.text;
              textController.clear();
              onValue(textValue);
            }));
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withAlpha(128),
      //       spreadRadius: 1,
      //       blurRadius: 2,
      //       offset: Offset(0, 0),
      //     ),
      //   ],
      // ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: TextFormField(
        focusNode: focusNode,
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        controller: textController,
        decoration: inputDecoration,
        onFieldSubmitted: (value) {
          focusNode.requestFocus();
          textController.clear();
          onValue(value);
        },
      ),
    );
  }
}
