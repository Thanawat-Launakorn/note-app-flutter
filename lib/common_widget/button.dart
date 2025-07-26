import 'package:flutter/material.dart';

enum ButtonType { success, error }

class Button extends StatelessWidget {
  const Button({
    required this.title,
    required this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.margin,
    this.disable = false,
    this.type = ButtonType.success,
    super.key,
  });
  final String title;
  final Function() onTap;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final EdgeInsetsGeometry? margin;
  final ButtonType? type;
  final bool disable;

  Color _getBaseButtonColor() {
    switch (type) {
      case ButtonType.success:
        return Colors.blue.shade600;

      case ButtonType.error:
        return Colors.red.shade600;

      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = disable ? Colors.grey : _getBaseButtonColor();

    final VoidCallback? _onTap = disable ? null : onTap;

    return Container(
      height: 50,
      margin: margin,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .2,
              blue: 0,
              green: 0,
              red: 0,
            ), // shadow color
            blurRadius: 8,
            offset: const Offset(0, 4), // horizontal and vertical offset
          ),
        ],
      ),
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(12),
        color: buttonColor,
        child: InkWell(
          onTap: _onTap,
          child: Row(
            children: [
              Container(
                width: 50,
                alignment: Alignment.center,
                child: prefixIcon ?? const SizedBox.shrink(),
              ),

              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Container(
                width: 50,
                alignment: Alignment.center,
                child: suffixIcon ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
