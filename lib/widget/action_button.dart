import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        color: Colors.amberAccent,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ));
  }
}
