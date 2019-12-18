import 'package:app/blocs/welcome/welcome_bloc.dart';
import 'package:app/blocs/welcome/welcome_event.dart';
import 'package:app/shared/widget/bounce_button.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'delayed_animation.dart';


class WelcomeScreen extends StatefulWidget {

  final WelcomeBloc welcomeBloc;

  const WelcomeScreen({@required this.welcomeBloc}) : assert(welcomeBloc != null);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return Scaffold(
      backgroundColor: Color(0xFF8185E2),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                AvatarGlow(
                  endRadius: 90,
                  duration: Duration(seconds: 2),
                  glowColor: Colors.white24,
                  repeat: true,
                  repeatPauseDuration: Duration(seconds: 2),
                  startDelay: Duration(seconds: 1),
                  child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        child: FlutterLogo(
                          size: 50.0,
                        ),
                        radius: 50.0,
                      )), 
                ),
                DelayedAimation(
                  child: Text(
                    "Привет",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(context).textTheme.display1.fontSize,
                        color: color),
                  ),
                  delay: delayedAmount + 1000,
                ),
                DelayedAimation(
                  child: Text(
                    "Это Tatar Learning",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                        color: color),
                  ),
                  delay: delayedAmount + 2000,
                ),
                SizedBox(
                  height: 30.0,
                ),
                DelayedAimation(
                  child: Text(
                    "Твой новый способ",
                    style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: color),
                  ),
                  delay: delayedAmount + 3000,
                ),
                DelayedAimation(
                  child: Text(
                    "Изучения татарского языка",
                    style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: color),
                  ),
                  delay: delayedAmount + 3000,
                ),
                SizedBox(
                  height: 100.0,
                ),
                DelayedAimation(
                  child: GestureDetector(
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    child: Transform.scale(
                      scale: _scale,
                      child: BounceButton(
                        text: 'Исәнме'
                      )
                    ),
                  ),
                  delay: delayedAmount + 4000,
                ),
              ],
            )
          ],
        )
      )
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse().whenComplete((){
      widget.welcomeBloc.add(UserInteracted());
    });
  }
}