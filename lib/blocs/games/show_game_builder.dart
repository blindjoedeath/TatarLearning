

import 'package:app/blocs/games/quiz_game/quiz_game_builder.dart';
import 'package:app/blocs/games/quiz_game/quiz_game_configuration.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_ink_well/image_ink_well.dart';

class ShowGameBuilder extends StatelessWidget{

  List<IntroPage> _buildIntros(){
    return [
      IntroPage(
        color: Colors.purple,
        title: "Покажи",
        body: "Игра, где нужно отвечать на вопрос \"Какая из?\" на время",
        imageUrl: "images/intro/show/1.png"
      ),
      IntroPage(
        color: Colors.indigo,
        title: "Что делать?",
        body: "Выберай картинку из предложенных, которая изображает слово",
        imageUrl: "images/intro/show/2.png"
      ),
      IntroPage(
        color: Colors.orange,
        title: "Результат",
        body: "В конце ты можешь сохранить слова, которые хочешь выучить!",
        imageUrl: "images/intro/show/3.png"
      ),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return QuizGameBuilder(
      configuration: QuizGameConfiguration(
        mainColor: Colors.cyan,
        secondColor: Colors.black45,
        screenType: Screen.WhatIsGame,
        intros: _buildIntros(),
        cardBuilder: (card, userAnswerd) => WhatIsCard(
          quizCard: card,
          userAnswered: userAnswerd,
        )
      ),
    );
  }

}

class WhatIsCard extends StatefulWidget{

  final QuizCard quizCard;
  final void Function(int) userAnswered;

  const WhatIsCard({@required this.quizCard, @required this.userAnswered});

  @override
  State<StatefulWidget> createState() => _WhatIsCardState();

}

class _WhatIsCardState extends State<WhatIsCard>{

    Widget _buildImage(QuizCard card, int index){
    return RoundedRectangleImageInkWell(
      onPressed: (){
        widget.userAnswered(index);
      },
      borderRadius: BorderRadius.circular(10),
      image: NetworkImage(
        card.variants[index].imageUrl,
      ),
      fit: BoxFit.cover,
      width: 120,
      height: 100,
    );
  }

  Widget _buildVariants(QuizCard card){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildImage(card, 0),
            _buildImage(card, 1),
          ],   
        ),
        Row(
          children: <Widget>[
            SizedBox(
              height: 10,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildImage(card, 2),
            _buildImage(card, 3),
          ],   
        )
      ],
    );
  }

  Widget _buildQuizCard(QuizCard card){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(35, 40),
          topRight: Radius.elliptical(35, 40)
        ),
        color: Colors.white,
        boxShadow: kElevationToShadow[4],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white.withAlpha(220), Colors.white],
          stops: [0.0, 0.1],
        ),
      ),
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 6,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(card.variants[card.answerIndex].word,
                    style: Theme.of(context).textTheme.display1),
            )
          ),
          Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 20,
            child: _buildVariants(card)
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuizCard(widget.quizCard);
  }

}