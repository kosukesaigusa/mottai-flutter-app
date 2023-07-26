import 'package:flutter/material.dart';

class SwitchingChip extends StatelessWidget {
  const SwitchingChip({
    required this.label,
    this.isEnabled = false,
    super.key,
  });

  final bool isEnabled;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      onPressed: () => {},
      isEnabled: isEnabled,
      side: isEnabled ? BorderSide.none : null,
      label: Text(label),
    );
  }
}
