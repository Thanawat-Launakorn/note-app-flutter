import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final dynamic fieldForm;
  final bool obscureText;
  final String hintText;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final Function(String? v)? onFieldSubmitted;
  const Input({
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.textStyle,
    this.hintText = '',
    this.onFieldSubmitted,
    this.obscureText = false,
    required this.fieldForm,
    super.key,
  });

  TextStyle textStyleFunc() {
    return textStyle ?? TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldForm['controller'],
      focusNode: fieldForm['focus'],
      textInputAction: textInputAction,
      obscureText: obscureText,
      onFieldSubmitted: (v) => onFieldSubmitted,
      style: textStyleFunc(),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
