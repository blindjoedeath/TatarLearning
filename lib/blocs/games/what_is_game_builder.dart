

import 'package:app/blocs/games/quiz_game/quiz_game_builder.dart';
import 'package:app/blocs/games/quiz_game/quiz_game_configuration.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:flutter/material.dart';

class WhatIsGameBuilder extends StatelessWidget{

  List<IntroPage> _buildIntros(){
    return [
      IntroPage(
        color: Colors.green,
        title: "Что это?",
        body: "Игра, где нужно отвечать на вопрос \"Что это?\" на время",
        imageUrl: "images/intro/what_is/1.png"
      ),
      IntroPage(
        color: Colors.blue,
        title: "Что делать?",
        body: "Выберай вариант из предложенных, что изображено на картинке",
        imageUrl: "images/intro/what_is/2.png"
      ),
      IntroPage(
        color: Colors.green,
        title: "Результат",
        body: "В конце ты можешь сохранить слова, которые хочешь выучить!",
        imageUrl: "images/intro/what_is/3.png"
      ),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return QuizGameBuilder(
      configuration: QuizGameConfiguration(
        screenType: Screen.ShowGame,
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

    Widget _buildChip(QuizCard card, int index){
    return Container(
      width: 130,
      height: 40,
      margin: EdgeInsets.all(6),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(card.variants[index].word, 
          style: Theme.of(context).textTheme.title.copyWith(
            color: Colors.white,
            fontSize: 20
          ),),
        color: Colors.teal,
        elevation: 4,   
        onPressed: () => widget.userAnswered(index),
      )
    );
  }

  Widget _buildVariants(QuizCard card){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildChip(card, 0),
            _buildChip(card, 1),
          ],   
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildChip(card, 2),
            _buildChip(card, 3),
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
            flex: 12,
            child: Container(
              padding: EdgeInsets.only(right: 30, left: 30, top: 60),
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    card.variants[card.answerIndex].imageUrl,
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.width * 0.8
                  ),
                )
              )
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 6,
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