import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

//takes delay and a widget as a child and control its entrance animation into the activity

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)), // opacity increase animation
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -130.0, end: 0.0),
          curve: Curves.easeOut) // y axis translation from the top
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]),
            child: child
        ),
      ),
    );
  }
}