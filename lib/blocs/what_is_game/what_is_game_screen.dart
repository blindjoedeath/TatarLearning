import 'package:app/blocs/what_is_game/what_is_game_intro.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/widget/bounce_button.dart';

import 'what_is_game_builder.dart';
import 'what_is_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'what_is_game_state.dart';
import 'what_is_game_event.dart';


class WhatIsGameScreen extends StatelessWidget {

  final WhatIsGameBloc whatIsGameBloc;

  const WhatIsGameScreen({@required this.whatIsGameBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhatIsGameBloc, WhatIsGameState>(
      builder: (context, state){
        if (state is ShowIntro){
          return Hero(
            tag: "whatIsHero",
            child: WhatIsGameIntro(
              whatIsGameBloc: whatIsGameBloc,
            )
          );
        } else {
          return Hero(
            tag: "whatIsHero",
            child: WhatIsGame()
          );
        }
      }
    );
  }

}

class WhatIsGame extends StatefulWidget{
  
  
  @override
  State<StatefulWidget> createState() => _WhatIsGameState();

}

class _WhatIsGameState extends State<WhatIsGame>{

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
          var bloc = BlocProvider.of<WhatIsGameBloc>(context);
          bloc.add(UserAnswered(
            answerIndex: index
          ));
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

  Widget _buildQuizCard(QuizCard card){
    return Padding(
      padding: EdgeInsets.only(right: 24, left: 24, top: 50, bottom: 64),
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 20, left: 20, top: 46),
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    card.imageUrl,
                    fit: BoxFit.fitHeight,
                    width: 240,
                  ),
                )
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: _buildVariants(card)
            )
          ],
        )
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
                SizedBox.expand(
                  child: (state is WaitForBegin) ? _buildAreYouReady() : 
                          (state is GameActive) ? _buildQuizCard(state.cards[state.currentCard]) :
                          (state is GameOver) ? _buildGameOver() :
                          _buildIndicator()
                )
              ] ,
            );
          },
        )
      )
    );
  }

}
			