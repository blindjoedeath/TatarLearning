import 'package:app/blocs/game_overview/game_overview_builder.dart';
import 'package:app/blocs/what_is_game/what_is_game_intro.dart';
import 'package:app/shared/entity/game_result.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/widget/bounce_button.dart';
import 'package:app/shared/widget/fly_animation.dart';
import 'package:app/shared/widget/time_line.dart';

import 'what_is_game_builder.dart';
import 'what_is_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'what_is_game_state.dart';
import 'what_is_game_event.dart';


class WhatIsGame extends StatefulWidget{
  
  final WhatIsGameBloc whatIsGameBloc;

  const WhatIsGame({@required this.whatIsGameBloc});
  
  @override
  State<StatefulWidget> createState() => _WhatIsGameState();

}

class _WhatIsGameState extends State<WhatIsGame> with TickerProviderStateMixin{

  AnimationController _cardController;
  AnimationController _progressController;

  @override
  void initState(){

    _progressController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this
    );

    _cardController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700)
    );
    super.initState();
  }

  @override
  void dispose(){
    _cardController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Widget _buildCloseButton(){
    return IconButton(
      icon: Icon(Icons.close,
        color: Colors.white70,
        size: 40,),
      onPressed: (){
        Navigator.pop(context);
      },
    );
  }

  Future _animateAnswer(){
    _progressController.reset();
    return _cardController.forward().whenComplete((){
      _cardController.reset();
    });
  }

  Widget _buildChip(QuizCard card, int index){
    return Container(
      width: 150,
      height: 40,
      margin: EdgeInsets.all(6),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(card.variants[index].word, 
          style: Theme.of(context).textTheme.title.copyWith(
            color: Colors.white,
            fontSize: 26
          ),),
        color: Colors.teal,
        elevation: 4,   
        onPressed: (){
          _animateAnswer().whenComplete((){
            widget.whatIsGameBloc.add(UserAnswered(
              answerIndex: index
            ));
          });
        },
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
          stops: [0.0, 0.4],
        ),
      ),
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 12,
            child: Container(
              padding: EdgeInsets.only(right: 20, left: 20, top: 46),
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    card.imageUrl,
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

  Widget _buildQuizScreen(GameActive state){
    var stackCount = 3;
    var cards = <Widget>[
      FlyAnimation(
        controller: _cardController,
        child: _buildQuizCard(state.cards[state.currentCard])
      )
    ];
    for(int i = 1; i < stackCount; ++i){
      if (state.currentCard + i < state.cards.length){
        cards.add(
          AnimatedPositioned(
            duration: Duration(milliseconds: _cardController.isAnimating ? 500 : 0),
            bottom: _cardController.isAnimating ? 20.0 * (i-1) : 20.0 * i,
            child: _buildQuizCard(
              state.cards[state.currentCard + i],
            )
          )
        );
      } else{
        break;
      }
    }

    var cardsStack = Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        overflow: Overflow.visible,
        children: cards.reversed.toList()
      )
    );
    return Stack(
      children:  <Widget>[
        cardsStack,
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 28,
            color: Colors.white,
            child: TimeLine(
              animationController: _progressController,
              duration: Duration(seconds: 5),
              onTimeout: (){
                _animateAnswer().whenComplete((){
                  widget.whatIsGameBloc.add(QuestionTimeout());
                });
              },
            )
          )
        )
      ],
    );
  }

  Widget _buildAreYouReady(){
    return Stack(
      children: [
        Center(
          child: Text(
            "Вы готовы?", 
            style: Theme.of(context).textTheme.display1.copyWith(
              color: Colors.white70
            )
          )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 46),
            child: BounceButton(
              onTap: (){       
                widget.whatIsGameBloc.add(UserIsReady());
              },
              width: 240,
              color: Colors.white70,
              child: Text(
                "Готов", 
                style: Theme.of(context).textTheme.headline.copyWith(
                  fontSize: 20,
                  color: Colors.teal
                ),
              ),
            )
          )
        ),
      ]
    );
  }

  Widget _buildIndicator(){
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white70,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
      )
    );
  }

  Widget _buildTopRow(WhatIsGameState state){
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_buildCloseButton()]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: state is GameActive ? [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("${state.currentCard+1}/${state.cards.length}",
                style: Theme.of(context).textTheme.display1.copyWith(
                  color: Colors.white70
                )
              )
            )
          ] : [],
        )
      ]
    );
  }

  Widget _buildGameOver(GameOver state){
    return GameOverviewBuilder(
      gameResult: state.gameResult
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: BlocBuilder<WhatIsGameBloc, WhatIsGameState>(
          bloc: widget.whatIsGameBloc,
          builder: (context, state){
            if (state is GameActive){
              _progressController.forward();
            }
            return Stack(
              children: <Widget>[
                _buildTopRow(state),
                (state is WaitForBegin) ? _buildAreYouReady() : 
                        (state is GameActive) ? _buildQuizScreen(state) :
                        (state is GameOver) ? _buildGameOver(state) :
                        _buildIndicator()
              ] ,
            );
          },
        )
      )
    );
  }

}
			