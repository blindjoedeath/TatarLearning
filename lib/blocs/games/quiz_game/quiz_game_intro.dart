import 'package:app/blocs/games/quiz_game/quiz_game_configuration.dart';
import 'package:app/blocs/games/quiz_game/quiz_game_event.dart';
import 'package:intro_views_flutter/Constants/constants.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

import 'quiz_game_bloc.dart';
import 'package:flutter/material.dart';

class QuizGameIntro extends StatelessWidget {

  final QuizGameBloc quizGameBloc;
  final List<IntroPage> intros;

  const QuizGameIntro({@required this.quizGameBloc, @required this.intros});

  PageViewModel _buildIntro(IntroPage intro){
    return PageViewModel(
      pageColor: intro.color,
      bubbleBackgroundColor: Colors.white54,
      body: Text(intro.body),
      title: Text(intro.title),
      mainImage: intro.imageUrl != null ? OverflowBox(
        maxWidth: 300,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              intro.imageUrl,
              filterQuality: FilterQuality.high,
              cacheHeight: 500,
            ),
          )
        )
      ) : Container(),
      titleTextStyle: TextStyle(color: Colors.white),
      bodyTextStyle: TextStyle(color: Colors.white, 
        fontSize: 22),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: IntroViewsFlutter(
            intros.map((i) => _buildIntro(i)).toList(),
            onTapNextButton: (){print("next");},
            onTapDoneButton: (){
              quizGameBloc.add(IntroIsOver());
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
			