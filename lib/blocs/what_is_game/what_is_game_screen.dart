import 'package:app/blocs/what_is_game/what_is_game_intro.dart';
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

  List<Widget> _buildAreYouReady(){
    return [
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
            onTap: (){},
            width: 240,
            color: Colors.white70,
            child: Text(
              "Готов", 
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.teal
              ),
            ),
          )
        )
      )
    ];
  }

  Widget _buildIndicator(){
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white70,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: BlocBuilder<WhatIsGameBloc, WhatIsGameState>(
          bloc: BlocProvider.of<WhatIsGameBloc>(context),
          builder: (context, state){
            var widgets;
            if (state is GameLoading){
              widgets = [_buildIndicator()]; 
            } else if (state is GameLoaded){
              widgets = _buildAreYouReady();
            }
            return Stack(
              children: <Widget>[
                _buildCloseButton()
              ] + widgets,
            );
          },
        )
      )
    );
  }

}
			