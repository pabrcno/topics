import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;

  const AppChip(
      {Key? key, required this.label, this.color, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      padding: const EdgeInsets.all(0),
      backgroundColor: backgroundColor,
      labelStyle: TextStyle(color: color),
    );
  }
}
