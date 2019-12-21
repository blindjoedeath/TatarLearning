import 'package:app/blocs/what_is_game/what_is_game_intro.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/widget/bounce_button.dart';
import 'package:app/shared/widget/fly_animation.dart';

import 'what_is_game_builder.dart';
import 'what_is_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'what_is_game_state.dart';
import 'what_is_game_event.dart';


class WhatIsGame extends StatefulWidget{
  
  
  @override
  State<StatefulWidget> createState() => _WhatIsGameState();

}

class _WhatIsGameState extends State<WhatIsGame> with SingleTickerProviderStateMixin{

  AnimationController _animationController;

  @override
  void initState(){
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700)
    );
    super.initState();
  }

  @override
  void dispose(){
    _animationController.dispose();
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

  Widget _buildChip(QuizCard card, int index){
    return Transform.scale(
      scale: 1.15,
      child: ActionChip(
        label: Text(card.variants[index], 
          style: Theme.of(context).textTheme.title.copyWith(
            color: Colors.white
          ),),
        backgroundColor: Colors.teal,
        elevation: 4,   
        pressElevation: 8,
        onPressed: (){
          _animationController.forward().whenComplete((){
            _animationController.reset();
            var bloc = BlocProvider.of<WhatIsGameBloc>(context);
            bloc.add(UserAnswered(
              answerIndex: index
            ));
          });
        },
      )
    );
  }

  Widget _buildVariants(QuizCard card){
    return Table(
      defaultColumnWidth: FixedColumnWidth(130),
      children: [
        TableRow(
          children: [
            _buildChip(card, 0),
            _buildChip(card, 1),
          ],   
        ),
        TableRow(
          children: [
            _buildChip(card, 2),
            _buildChip(card, 3),
          ],   
        )
      ],
    );
  }

  Widget _buildQuizCard(QuizCard card, {double elevation = 4.0}){
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Card(
        elevation: elevation,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 20, left: 20, top: 46),
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    card.imageUrl,
                    fit: BoxFit.fitHeight,
                    height: 250,
                  ),
                )
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: _buildVariants(card)
              )
            )
          ],
        )
      )
    );
  }

  Widget _buildQuizScreen(GameActive state){
    var stackCount = 4;
    var cards = <Widget>[
      FlyAnimation(
        controller: _animationController,
        child: _buildQuizCard(state.cards[state.currentCard], elevation: 0)
      )
    ];
    for(int i = 1; i < stackCount; ++i){
      if (state.currentCard + i < state.cards.length){
        cards.add(
          Positioned(
            bottom: -20.0 * (i-1),
            child: _buildQuizCard(
              state.cards[state.currentCard + i],
            )
          )
        );
      } else{
        break;
      }
    }

    return Align(
      alignment: Alignment.center,
      child: Stack(
        overflow: Overflow.visible,
        children: cards.reversed.toList()
      )
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
                var bloc = BlocProvider.of<WhatIsGameBloc>(context);
                bloc.add(UserIsReady());
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
        )
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

  Widget _buildGameOver(){
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: BlocBuilder<WhatIsGameBloc, WhatIsGameState>(
          bloc: BlocProvider.of<WhatIsGameBloc>(context),
          builder: (context, state){
            return Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [_buildCloseButton()]
                ),
                (state is WaitForBegin) ? _buildAreYouReady() : 
                        (state is GameActive) ? _buildQuizScreen(state) :
                        (state is GameOver) ? _buildGameOver() :
                        _buildIndicator()
              ] ,
            );
          },
        )
      )
    );
  }

}
			