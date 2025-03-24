import 'package:flutter/material.dart';
import 'package:monalisa_app_001/config/config.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? labelTop;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final String initialValue;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool border;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final bool autofocus;
  final bool readOnly;

  const CustomTextFormField({
    super.key,
    this.label,
    this.labelTop,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.initialValue = '',
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.border = true,
    this.prefixIcon,
    this.suffixIcon,
    this.textAlign = TextAlign.left,
    this.autofocus = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide:
          BorderSide(color: border ? themeColorGrayLight : Colors.transparent),
      borderRadius: BorderRadius.circular(themeBorderRadius),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelTop != null
            ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(labelTop!,
                    style: TextStyle(fontSize: themeFontSizeSmall)),
              )
            : SizedBox(),
        Container(
          decoration: BoxDecoration(
            color: border ? themeBackgroundColorLight : themeBackgroundColor,
            borderRadius: BorderRadius.circular(themeBorderRadius),
            boxShadow: border
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: SizedBox(
            height: 40,
            child: TextFormField(
              textAlign: textAlign,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              validator: validator,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: themeFontSizeNormal,
              ),
              maxLines: maxLines,
              initialValue: initialValue,
              autofocus: autofocus,
              readOnly: readOnly,
              decoration: InputDecoration(
                floatingLabelBehavior: maxLines > 1
                    ? FloatingLabelBehavior.always
                    : FloatingLabelBehavior.auto,
                floatingLabelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: themeFontSizeNormal,
                ),
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
                errorBorder: inputBorder.copyWith(
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedErrorBorder: inputBorder.copyWith(
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                isDense: true,
                label: label != null ? Text(label!) : null,
                hintText: hint,
                errorText: errorMessage,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
