import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimateButton extends StatefulWidget {
  final Function? pressEvent;
  final Widget? body;
  final IconData? icon;
  final double width;
  final bool isFixedHeight;
  final Color? color;

  const AnimateButton(
      {required this.pressEvent,
        this.body,
        this.icon,
        this.color,
        this.isFixedHeight = true,
        this.width = double.infinity});
  @override
  _AnimateButtonState createState() => _AnimateButtonState();
}

class _AnimateButtonState extends State<AnimateButton> with AnimationMixin {
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    final curveAnimation = CurvedAnimation(
        parent: controller, curve: Curves.bounceOut, reverseCurve: Curves.bounceOut);
    _scale = Tween<double>(begin: 1, end: 0.9).animate(curveAnimation);
  }

  void _onTapDown(TapDownDetails details) {
    controller.play(duration: Duration(milliseconds: 150));
  }

  void _onTapUp(TapUpDetails details) {
    if (controller.isAnimating) {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed)
          controller.playReverse(duration: Duration(milliseconds: 100));
      });
    } else
      controller.playReverse(duration: Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.pressEvent!();
        //  _controller.forward();
      },
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        controller.playReverse(
          duration: Duration(milliseconds: 100),
        );
      },
      child: Transform.scale(
        scale: _scale.value,
        child: _animateButtonUI,
      ),
    );
  }

  Widget get _animateButtonUI => Container(
    height: widget.isFixedHeight ? 50.0 : null,
    width: widget.width,
    child: widget.body,
  );

}
