import 'package:flutter/material.dart';

class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            leading: _ColorSquare(colorScheme.primary),
            title: const Text('Primary'),
            subtitle: Text(colorScheme.primary.toString()),
          ),
          ListTile(
            leading: _ColorSquare(colorScheme.secondary),
            title: const Text('Secondary'),
            subtitle: Text(colorScheme.secondary.toString()),
          ),
          ListTile(
            leading: _ColorSquare(colorScheme.tertiary),
            title: const Text('Tertiary'),
            subtitle: Text(colorScheme.tertiary.toString()),
          ),
          ListTile(
            leading: _ColorSquare(colorScheme.onSurface),
            title: const Text('On Surface'),
            subtitle: Text(colorScheme.onSurface.toString()),
          ),
        ],
      ),
    );
  }
}

class _ColorSquare extends StatelessWidget {
  const _ColorSquare(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: const SizedBox.square(dimension: 40),
    );
  }
}
