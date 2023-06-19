import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/theme_provider.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key? key}) : super(key: key);

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.linear);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double maxHeight = constraints.maxHeight;

      return Column(
        children: [
          AnimatedBuilder(
            animation: _curve,
            builder: (BuildContext context, Widget? child) {
              return Transform.translate(
                offset: Offset(0, (.8 * sin((_curve.value * 2 * pi)) * 10)),
                child: Transform.rotate(
                  angle: sin(1.5 * ((_curve.value * 2 * pi))) * .05,
                  child: Image(
                    image: AssetImage(Provider.of<ThemeProvider>(context)
                        .logoUrl), // path to your logo image
                    width: maxHeight * .7,
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: maxHeight * .2,
          ),
          AnimatedBuilder(
              animation: _curve,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                    scale: max(.2, .3 * sin((_curve.value * 2 * pi)) + .8),
                    child: Opacity(
                        opacity: .2,
                        child: Container(
                          width: maxHeight * .4,
                          height: maxHeight * .05,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.shadow,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        )));
              })
        ],
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
