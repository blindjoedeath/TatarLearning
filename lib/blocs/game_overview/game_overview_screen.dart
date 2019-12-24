import 'package:app/shared/entity/game_result.dart';
import 'package:app/shared/entity/word_card.dart';

import 'game_overview_builder.dart';
import 'game_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_overview_state.dart';
import 'game_overview_event.dart';


class GameOverviewScreen extends StatelessWidget {

  final GameResult gameResult;

  final GameOverviewBloc gameOverviewBloc;

  const GameOverviewScreen({@required this.gameOverviewBloc, @required this.gameResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Результат"),),
      body: ListView.builder(
        itemBuilder: (context, index){
          var card = gameResult.getCard(index);
          var isCorrect = gameResult.answers[index];
          return Container(
            color: (isCorrect ? Colors.green : Colors.red).withAlpha(50),
            child: ListTile(
              title: Text(card.word),
              subtitle: Text(card.translates[0]),
              leading: Padding(
                padding: EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: FadeInImage(
                    image: NetworkImage(card.imageUrl),
                    placeholder: AssetImage("images/100.png"),
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  )
                ),
              ),
              trailing: BlocBuilder<GameOverviewBloc, GameOverviewState>(
                bloc: gameOverviewBloc,
                builder: (context, state){
                  return IconButton(
                    icon: Icon(state.isWordAdded[index] ? Icons.done : Icons.add,
                      color: Colors.blue,
                    ),
                    onPressed: (){
                      gameOverviewBloc.add(WordAddedStateChanged(
                        index: index
                      ));
                    },
                  );
                },
              )
            )
          );
        },
        itemCount: gameResult.quizCards.length,
      ),
    );
  }

}
			