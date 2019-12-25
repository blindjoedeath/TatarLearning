import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class TimeLine extends StatefulWidget{

  final Color color;
  final AnimationController animationController;
  final Duration duration;
  final void Function() onTimeout;
  
  const TimeLine({@required this.duration, @required this.animationController,
                   this.onTimeout, this.color = Colors.green});

  @override
  State<StatefulWidget> createState() => _TimeLineState();

}

class _TimeLineState extends State<TimeLine> with SingleTickerProviderStateMixin{


  void animationListener(){
    setState(() {
      if (widget.animationController.isCompleted && widget.onTimeout != null){
        widget.onTimeout();
      }
    });
  }

  @override
  void initState() {
    widget.animationController.addListener(animationListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.animationController.removeListener(animationListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: widget.animationController.isAnimating ?
        LiquidLinearProgressIndicator(
          value: 1 - widget.animationController.value,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(widget.color),
        ) : Container()
    );
  }

}