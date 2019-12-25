import 'package:app/blocs/which_of_game/which_of_game_event.dart';
import 'package:intro_views_flutter/Constants/constants.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

import 'which_of_game_bloc.dart';
import 'package:flutter/material.dart';

class WhichOfGameIntro extends StatelessWidget {

  final WhichOfGameBloc whichOfGameBloc;

  WhichOfGameIntro({@required this.whichOfGameBloc});

  var first = PageViewModel(
    pageColor: Colors.purple,
    bubbleBackgroundColor: Colors.white54,
    body: Text(
      'Игра, где нужно отвечать на вопрос \"Какая из?\" на время',
    ),
    title: Text('Какая из?'),
    mainImage: Image.asset(
      'images/quiz/1.png',
      height: 220.0,
      width: 220.0,
      alignment: Alignment.center,
    ),
    titleTextStyle: TextStyle(color: Colors.white),
    bodyTextStyle: TextStyle(color: Colors.white, 
      fontSize: 22),
  );

  var second = PageViewModel(
    pageColor: Colors.blue,
    bubbleBackgroundColor: Colors.white54,
    body: Text(
      'Выберай картинку из предложенных, которая изображает слово',
    ),
    title: Text('Что делать?'),
    mainImage: OverflowBox(
      maxWidth: 300,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            'images/quiz/2.png',
          ),
        )
      )
    ),
    titleTextStyle: TextStyle(color: Colors.white),
    bodyTextStyle: TextStyle(color: Colors.white, 
      fontSize: 22),
  );

  var third = PageViewModel(
    pageColor: Colors.purple,
    bubbleBackgroundColor: Colors.white54,
    body: Text(
      'В конце ты можешь сохранить слова, которые хочешь выучить!',
    ),
    title: Text('Результат'),
    mainImage: OverflowBox(
      maxWidth: 300,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            'images/quiz/3.png',
          ),
        )
      )
    ),
    titleTextStyle: TextStyle(color: Colors.white),
    bodyTextStyle: TextStyle(color: Colors.white, 
      fontSize: 22),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: IntroViewsFlutter(
            [first, second, third],
            onTapNextButton: (){print("next");},
            onTapDoneButton: (){
              whichOfGameBloc.add(IntroIsOver());
            },
            showSkipButton: false,
            doneText: const Text("ОК!"),
            pageButtonTextStyles: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          )
        )
      )
    );
  }
}
			