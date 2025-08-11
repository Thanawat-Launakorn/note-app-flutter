import 'package:app/common_widget/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Action { setpin, loginpin }

class Pincode extends StatefulWidget {
  final int length;
  final Action action;
  final Function()? onLoginUsername;
  final Function(String pincode) onSubmitHandler;
  const Pincode({
    this.action = Action.loginpin,
    this.onLoginUsername,
    this.length = 6,

    required this.onSubmitHandler,
    super.key,
  });

  @override
  State<Pincode> createState() => _PincodeState();
}

class _PincodeState extends State<Pincode> {
  String number = '';
  String title = '';
  String pin = '';

  bool shake = false;
  setValue(String val) {
    if (number.length < widget.length) {
      setState(() {
        number += val;
        if (number.length == widget.length) {
          final pincode = number;
          onPinEnter(pincode);
        }
      });
    }
  }

  onError() {
    setState(() {
      shake = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        shake = false;
      });
    });
  }

  onPinEnter(String pincode) {
    setState(() {
      number = '';
    });

    if (widget.action == Action.loginpin) {
      // setShake when wrong use with loginpincode

      setState(() {
        number = '';
      });

      // Optional: reset after shake
    } else {
      if (pin.isNotEmpty) {
        debugPrint('pin is notEmpty $pin, $pincode');

        // check p_previous is match p_confirmpin
        if (pin == pincode) {
          debugPrint('call api setpin');
          widget.onSubmitHandler(pincode);
          // call api
        } else {
          setState(() {
            pin = '';
          });

          onError();
          return;
        }
      }

      setState(() {
        pin = pincode;
      });
    }

    debugPrint('onFinish Process');
  }

  backspace(String text) {
    if (text.isNotEmpty) {
      setState(() {
        number = text.split('').sublist(0, text.length - 1).join('');
      });
    }
  }

  Widget renderTitle() {
    TextStyle fontStyle = TextStyle(fontSize: 24);
    if (widget.action == Action.setpin) {
      String t;
      debugPrint('pin => $pin');

      if (pin.isEmpty) {
        t = 'set pin';
      } else {
        t = 'confirm pin';
      }

      return Text(t, style: fontStyle);
    }

    return Placeholder();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // --- Dot ---
          Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Spacer(), renderTitle(), Spacer()],
                ),
              ),

              Preview(shouldShake: shake, text: number, length: 6),

              // --- Numpad ---
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NumpadButton(text: '1', onPress: () => setValue('1')),
                  NumpadButton(text: '2', onPress: () => setValue('2')),
                  NumpadButton(text: '3', onPress: () => setValue('3')),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  NumpadButton(text: '4', onPress: () => setValue('4')),
                  NumpadButton(text: '5', onPress: () => setValue('5')),
                  NumpadButton(text: '6', onPress: () => setValue('6')),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  NumpadButton(text: '7', onPress: () => setValue('7')),
                  NumpadButton(text: '8', onPress: () => setValue('8')),
                  NumpadButton(text: '9', onPress: () => setValue('9')),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  // feature bio
                  NumpadButton(icon: Icons.fingerprint, onPress: () {}),
                  NumpadButton(
                    text: '0',
                    onPress: () {
                      setValue('0');
                    },
                  ),
                  NumpadButton(
                    icon: Icons.arrow_back_rounded,
                    onPress: () {
                      backspace(number);
                    },
                  ),
                ],
              ),
            ],
          ),

          if (widget.action == Action.loginpin)
            Container(
              margin: EdgeInsets.only(bottom: 45, right: 16, left: 16),
              child: Button(
                title: 'login username and password',
                onTap: () {
                  if (widget.onLoginUsername != null) {
                    widget.onLoginUsername!();
                  }
                  context.replace('/login');
                },
              ),
            ),
        ],
      ),
    );
  }
}

class Preview extends StatefulWidget {
  final int length;
  final String text;
  final bool shouldShake; // new prop to trigger shaking

  const Preview({
    required this.length,
    required this.text,
    required this.shouldShake,
    super.key,
  });

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void didUpdateWidget(covariant Preview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldShake && !oldWidget.shouldShake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              children: List.generate(widget.length, (i) {
                return Dot(
                  isActive: widget.text.length > i,
                  shake: widget.shouldShake,
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class Dot extends StatelessWidget {
  final bool isActive;
  final bool shake;
  const Dot({required this.shake, required this.isActive, super.key});

  @override
  Widget build(BuildContext context) {
    Color dotColor() {
      Color result;
      if (isActive) {
        result = Theme.of(context).primaryColor;
      } else if (shake) {
        result = Colors.red;
      } else {
        result = Colors.transparent;
      }

      return result;
    }

    return Container(
      padding: EdgeInsets.all(8),
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: dotColor(),
          border: Border.all(
            width: 1,
            color: shake ? Colors.red : Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class NumpadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Function() onPress;
  const NumpadButton({required this.onPress, this.text, this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle buttonStyle = TextStyle(
      fontSize: 32,
      color: Theme.of(context).primaryColor,
    );
    Widget label =
        icon != null
            ? Icon(icon, color: Theme.of(context).primaryColor)
            : Text(text ?? '', style: buttonStyle);
    return Container(
      margin: EdgeInsets.all(10),
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: onPress,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(child: label),
          ),
        ),
      ),
    );
  }
}
