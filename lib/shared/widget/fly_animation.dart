

import 'package:flutter/material.dart';

class FlyAnimation extends StatefulWidget{

  final AnimationController controller;
  final Widget child;

  const FlyAnimation({@required this.child, @required this.controller});

  @override
  State<StatefulWidget> createState() => _FlyAnimationState();

}

class _FlyAnimationState extends State<FlyAnimation> with SingleTickerProviderStateMixin{

  Animation<double> _fadeAnimation;
  Animation<Offset> _slideAnimation;
  Animation<double> _scaleAnimation;

  @override
  void initState() {

    var curve = CurvedAnimation(
      curve: Curves.decelerate,
      parent: widget.controller
    );

    _fadeAnimation = ReverseTween(
      Tween(
        begin: 0.0, end: 1.0
      )
    ).animate(curve);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-2, -0.1),
    ).animate(curve);

    _scaleAnimation = Tween(
        begin: 1.0, end: 1.1
    ).animate(curve);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        )
      )
    );
  }

}