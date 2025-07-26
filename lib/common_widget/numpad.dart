import 'package:flutter/material.dart';

class Numpad extends StatefulWidget {
  const Numpad({required this.length, required this.onChange, super.key});
  final int length;
  final Function onChange;
  @override
  State<Numpad> createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {
  String number = '';

  setValue(String val) {
    if (number.length < widget.length) {
      setState(() {
        number += val;
        widget.onChange(number);
      });
    }
  }

  backspace(String text) {
    if (text.length > 0) {
      setState(() {
        number = text.split('').sublist(0, text.length - 1).join('');
        widget.onChange(number);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Preview(length: widget.length, text: number)
        ],
      ),
    );
  }
}

class Preview extends StatelessWidget {
  final int length;
  final String text;
  const Preview({required this.length,required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> previewLength = [];
    for (var i = 0; i < length; i++) {
      previewLength.add(Dot(isActive: text.length >= i + 1));
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Wrap(children: previewLength),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({required this.isActive, super.key});
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.transparent,
          border: Border.all(width: 1, color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class NumpadButton extends StatelessWidget {
  const NumpadButton({
    required this.text,
    required this.icon,
    required this.haveBorder,
    required this.onPressed,
    super.key,
  });
  final String text;
  final IconData icon;
  final bool haveBorder;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    TextStyle buttonStyle = TextStyle(fontSize: 22, color: Colors.blue);
    Widget label =
        icon != null
            ? Icon(
              icon,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              size: 35.0,
            )
            : Text(this.text ?? '', style: buttonStyle);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: OutlinedButton(
        
        onPressed: onPressed, child: label),
    );
  }
}
