import 'package:app/blocs/word_card_edit/word_card_edit_builder.dart';
import 'package:app/shared/entity/user.dart';
import 'package:app/shared/entity/word_card.dart';

import 'dictionary_builder.dart';
import 'dictionary_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dictionary_state.dart';
import 'dictionary_event.dart';


class DictionaryScreen extends StatelessWidget {

  final DictionaryBloc dictionaryBloc;

  const DictionaryScreen({@required this.dictionaryBloc});


  PageRouteBuilder _createRoute(WordCard card){
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => WordCardEditBuilder(
        wordCard: card,
      ),
      transitionsBuilder: (c, anim, a2, child) => FadeTransition(
        opacity: CurvedAnimation(
          curve: Curves.fastOutSlowIn,
          parent: anim,
        ),
        child: child)
        ,
      transitionDuration: Duration(milliseconds: 350),
    );
  }

  Widget _buildList(CardsLoaded state){
    return ListView.builder(
      itemBuilder: (context, index){
        var card = state.cards[index];
        return Container(
          child: Dismissible(
            background: Container(color: Colors.red),
            onDismissed: (direction){
              dictionaryBloc.add(CardRemoved(index: index));
              Scaffold
                .of(context)
                .showSnackBar(SnackBar(content: Text("Слово удалено.")));
            },
            key: Key(card.hashCode.toString()),
            child: ListTile(
              title: Text(card.word),
              subtitle: Text(card.translates[0]),
              leading: Padding(
                padding: EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Hero(
                    tag: "card-${card.translates.hashCode}",
                    child: FadeInImage(
                      image: NetworkImage(card.imageUrl),
                      placeholder: AssetImage("images/100.png"),
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    )
                  )
                ),
              ),
              onTap: (){
                Navigator.push(context, _createRoute(card));
              },
            )
          )
        );
      },
      itemCount: state.cards.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Словарь"),),
      body: BlocBuilder(
        bloc: dictionaryBloc,
        builder: (context, state){
          if (state is CardsLoaded){
            return _buildList(state);
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator()
              )
            ],
          );
        },
      )
    );
  }

}
			