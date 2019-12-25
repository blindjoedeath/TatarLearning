import 'package:app/shared/entity/word_card.dart';

import 'word_card_edit_builder.dart';
import 'word_card_edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'word_card_edit_state.dart';
import 'word_card_edit_event.dart';


class WordCardEditScreen extends StatefulWidget {

  final WordCardEditBloc wordCardEditBloc;

  final WordCard wordCard;

  const WordCardEditScreen({@required this.wordCardEditBloc, 
                              @required this.wordCard});

  @override
  State<StatefulWidget> createState() => _WordCardEditScreenState();

}

class _WordCardEditScreenState extends State<WordCardEditScreen>{

  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _translateController = TextEditingController();

  @override
  void initState(){
    _wordController.value = _wordController.value.copyWith(
      text: widget.wordCard.word
    );
    _translateController.value = _translateController.value.copyWith(
      text: widget.wordCard.translates[0]
    );
    super.initState();
  }

  Widget _buildImage(BuildContext context){
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            alignment: Alignment.center,
            child: Hero(
              tag: "card-${widget.wordCard.translates.hashCode}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.wordCard.imageUrl,
                  fit: BoxFit.fitHeight,
                  width: 240,
                ),
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _wordController,
              style: Theme.of(context).textTheme.headline
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _translateController,
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
            Text(widget.wordCard.description,
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
    return WillPopScope(
      onWillPop: (){
        widget.wordCardEditBloc.add(Save(
          card: widget.wordCard,
          word: _wordController.text.trim(),
          translate: _translateController.text.trim()
        ));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.wordCard.word),
        ),
        body: ListView(
          children: <Widget>[
            _buildImage(context),
            _buildContent(context)
          ],
        )
      )
    );
  }

}
			
			