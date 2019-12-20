

import 'package:flutter/material.dart';

class BounceButton extends StatefulWidget{

  final double width;
  final double height;
  final Color color;
  final Widget child; 
  final void Function() onTap;

  const BounceButton({@required this.child, @required this.onTap,
                      this.width = 270, this.height = 60,
                      this.color = Colors.white});

  @override
  State<StatefulWidget> createState() => _BounceButtonState();

}

class _BounceButtonState extends State<BounceButton> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 250,
      ),
    );
    _animation = ReverseTween<double>(
      Tween(
        begin: 0.9,
        end: 1,
      )
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn
    ));
    super.initState();
  }


  Widget get _animatedButtonUI => Container(
    height: widget.height,
    width: widget.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color: widget.color,
    ),
    child: Center(
      child: widget.child
    ),
  );

  void _onTapDown() {
    _controller.forward(from: 0.1);
  }

  void _onTapUp() {
    _controller.reverse().whenComplete((){
      widget.onTap();
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) => _onTapDown(),
      onTapUp: (d) => _onTapUp(),
      onTapCancel: () => _onTapUp(),
      child: ScaleTransition(
        scale: _animation,
        child: _animatedButtonUI
      ),
    );
  }

}