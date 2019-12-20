import 'dart:async';

import 'package:flutter/material.dart';

class DelayedAimation extends StatefulWidget {
  final Widget child;
  final int delay;

  DelayedAimation({@required this.child, this.delay});

  @override
  _DelayedAimationState createState() => _DelayedAimationState();
}

class _DelayedAimationState extends State<DelayedAimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animOffset;
  ValueNotifier<bool> _showChild = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _controller);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);

    if (widget.delay == null) {
      _controller.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _controller.forward();
        _controller.addListener(_controllerListener);
      });
    }
  }

  void _controllerListener(){
    var value = _controller.status == AnimationStatus.completed ||
      _controller.status == AnimationStatus.forward;
    _showChild.value = value;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_controllerListener);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: ValueListenableBuilder(
          valueListenable: _showChild,
          builder: (context, value, child){
            return value ? widget.child : Container();
          },
        ),
      ),
      opacity: _controller,
    );
  }
}