import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  const IconWithText({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 64, color: Theme.of(context).colorScheme.secondary),
        Text(text),
      ],
    );
  }
}
