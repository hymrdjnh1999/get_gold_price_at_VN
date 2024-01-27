import 'package:flutter/material.dart';

class MyButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onPress;
  const MyButtonWidget({super.key, required this.child, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPress,
      child: child,
    );
  }
}
