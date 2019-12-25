import 'package:app/blocs/game_overview/game_overview_builder.dart';
import 'package:app/blocs/games/quiz_game/quiz_game_configuration.dart';
import 'package:app/blocs/games/quiz_game/quiz_game_intro.dart';
import 'package:app/shared/entity/game_result.dart';
import 'package:app/shared/entity/quiz_card.dart';
import 'package:app/shared/widget/bounce_button.dart';
import 'package:app/shared/widget/fly_animation.dart';
import 'package:app/shared/widget/time_line.dart';

import 'quiz_game_builder.dart';
import 'quiz_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'quiz_game_state.dart';
import 'quiz_game_event.dart';


class QuizGame extends StatefulWidget{
  
  final Color mainColor;
  final Color secondColor;
  final QuizGameBloc quizGameBloc;
  final Widget Function(QuizCard, void Function(int)) cardBuilder;

  const QuizGame({@required this.quizGameBloc, @required this.cardBuilder,
                  @required this.mainColor, @required this.secondColor});
  
  @override
  State<StatefulWidget> createState() => _QuizGameState();

}

class _QuizGameState extends State<QuizGame> with TickerProviderStateMixin{

  AnimationController _cardController;
  AnimationController _progressController;
  ValueNotifier<AnimationStatus> _animationStatus;

  void _controllerListener(AnimationStatus status){
    _animationStatus.value = status;
  }

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
    _cardController.addStatusListener(_controllerListener);
    _animationStatus = ValueNotifier(_cardController.status);
    super.initState();
  }

  @override
  void dispose(){
    _cardController.removeStatusListener(_controllerListener);
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

  void _unserAnswered(int index){
    _animateAnswer().whenComplete((){
      widget.quizGameBloc.add(UserAnswered(
        answerIndex: index
      ));
    });
  }

  Widget _buildQuizScreen(GameActive state){
    var stackCount = 3;
    var cards = <Widget>[
      FlyAnimation(
        controller: _cardController,
        child: widget.cardBuilder(state.cards[state.currentCard], _unserAnswered)
      )
    ];
    for(int i = 1; i < stackCount; ++i){
      if (state.currentCard + i < state.cards.length){
        cards.add(
          ValueListenableBuilder(
            valueListenable: _animationStatus,
            child: widget.cardBuilder(
              state.cards[state.currentCard + i],
              _unserAnswered
            ),
            builder: (context, value, child){
              return AnimatedPositioned(
                duration: Duration(milliseconds: value == AnimationStatus.forward ? 500 : 0),
                bottom: value == AnimationStatus.forward ? 20.0 * (i-1) : 20.0 * i,
                child: child
              );
            },
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
          child: ValueListenableBuilder(
            valueListenable: _animationStatus,
            child: TimeLine(
              color: widget.mainColor,
              animationController: _progressController,
              duration: Duration(seconds: 5),
              onTimeout: (){
                _animateAnswer().whenComplete((){
                  widget.quizGameBloc.add(QuestionTimeout());
                });
              },
            ),
            builder: (context, value, child){
              var isLast = false;
              if (state is GameActive){
                isLast = state.currentCard == state.cards.length-1;
              }
              print(isLast);
              return Container(
                alignment: Alignment.bottomCenter,
                height: 28,
                color: value == AnimationStatus.forward && !isLast ? Colors.white : Colors.transparent,
                child: child
              );
            },
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
                widget.quizGameBloc.add(UserIsReady());
              },
              width: 240,
              color: Colors.white70,
              child: Text(
                "Готов", 
                style: Theme.of(context).textTheme.headline.copyWith(
                  fontSize: 20,
                  color: widget.secondColor
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
        valueColor: AlwaysStoppedAnimation<Color>(widget.secondColor),
      )
    );
  }

  Widget _buildTopRow(QuizGameState state){
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
    print(widget.mainColor);
    print(Colors.green);
    return Scaffold(
      backgroundColor: widget.mainColor,
      body: SafeArea(
        child: BlocBuilder<QuizGameBloc, QuizGameState>(
          bloc: widget.quizGameBloc,
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
			