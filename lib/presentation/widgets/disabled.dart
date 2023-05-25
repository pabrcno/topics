import 'package:flutter/material.dart';

class Disabled extends StatelessWidget {
  final bool disabled;
  final Widget child;
  final double opacity;

  const Disabled({
    Key? key,
    required this.child,
    this.disabled = false,
    this.opacity = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Opacity(
        opacity: disabled ? opacity : 1.0,
        child: child,
      ),
    );
  }
}
