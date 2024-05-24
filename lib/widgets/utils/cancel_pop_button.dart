import 'package:flutter/material.dart';

class CancelPopButton extends StatelessWidget {
  final bool disabled;
  const CancelPopButton({super.key, required this.disabled});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: !disabled ? () => Navigator.pop(context) : null,
      child: const Text("Cancel"),
    );
  }
}
