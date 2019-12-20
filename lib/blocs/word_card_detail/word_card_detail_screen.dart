import 'package:app/shared/entity/word_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'word_card_detail_builder.dart';
import 'word_card_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'word_card_detail_state.dart';
import 'word_card_detail_event.dart';


class WordCardDetailScreen extends StatelessWidget {

  final WordCardDetailBloc wordCardDetailBloc;

  final WordCard wordCard;

  const WordCardDetailScreen({@required this.wordCardDetailBloc, 
                              @required this.wordCard});

  Widget _buildImage(BuildContext context){
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            alignment: Alignment.center,
            child: Hero(
              tag: "card-${wordCard.translates.hashCode}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  wordCard.imageUrl,
                  fit: BoxFit.fitHeight,
                  width: 240,
                ),
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Text(wordCard.word,
              style: Theme.of(context).textTheme.headline
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Text(wordCard.translates[0],
              style: Theme.of(context).textTheme.headline
            ),
          )
        ],
      )
    );
  }

  Widget _buildContent(BuildContext context){
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: 12, bottom: 12),
        child: Column(
          children: <Widget>[
            Text(wordCard.description,
              style: Theme.of(context).textTheme.subhead.copyWith(
                color: Colors.black54
              )
            )
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wordCard.word),
        actions: <Widget>[
          BlocBuilder<WordCardDetailBloc, WordCardDetailState>(
            bloc: wordCardDetailBloc,
            builder: (context, state){
              return IconButton(
                icon: Icon(state.wordAdded ? Icons.done : Icons.add),
                onPressed: (){
                  wordCardDetailBloc.add(WordAddedStateChanged());
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text("Слово " + (state.wordAdded ? "удалено" : "сохранено") + "."),
                    )
                  );
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildImage(context),
          _buildContent(context)
        ],
      )
    );
  }

}
			