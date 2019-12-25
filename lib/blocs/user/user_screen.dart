import 'package:app/blocs/dictionary/dictionary_builder.dart';
import 'package:app/shared/entity/user.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/provider/mock_quiz_card_provider.dart';

import 'user_builder.dart';
import 'user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';
import 'user_event.dart';


class UserScreen extends StatefulWidget {

  final UserBloc userBloc;

  const UserScreen({@required this.userBloc});

  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isEmailAddressValid {
    RegExp exp = new RegExp (
      r"^[\w-.]+@([\w-]+.)+[\w-]{2,4}$",
      caseSensitive: false,
      multiLine: false,
    );
    return exp.hasMatch(_emailController.text.trim());
  }

  void _onLogin(){
    if (isEmailAddressValid){
      widget.userBloc.add(
        LoginTrial(
          login: _emailController.text,
          password: _passwordController.text
        )
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Ошибка"),
          content: Text("Некорректный логин"),
        )
      );
    }
  }

  List<Widget> _getCards(){
    List<Widget> cards = List<Widget>();
    MockQuizCardProvider().mockCards.forEach((c) =>{
      c.variants.forEach((a){
        cards.add(
          Image.network(
            a.imageUrl,
            width: 100,
            height: 100,
          )
        );
      })
    });
    return cards;
  }

  Widget _buildAvatar(User user){
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.avatarUrl),
                    fit: BoxFit.cover
                  )
                ),
              )
            )
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(user.name,
                  style: Theme.of(context).textTheme.headline.copyWith(
                    color: Colors.black54
                  )
                ),
                SizedBox(width: 10,),
                Text(user.surname, 
                  style: Theme.of(context).textTheme.headline.copyWith(
                    color: Colors.black54
                  )
                )
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: MaterialButton(
              color: Colors.blue,
              child: Text("Мой словарь", style: 
                Theme.of(context).textTheme.title.copyWith(
                  color: Colors.black54
                ),
              ),
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DictionaryBuilder()
                  )
                );
              },
            )
          )
        ]
      )
    );
  }

  Widget _buildAuthenticated(Authenticated state){
    return ListView(
      children: <Widget>[        
        _buildAvatar(state.user),
      ]
    );
  }

  Widget _buildLogin({bool loading=false}) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 12, left: 12, top: 46),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Email'
            ),
          ),
        ),
        Container(
          child: TextField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Пароль'
            ),
            obscureText: true,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        MaterialButton(
          onPressed: _onLogin,
          child: Text("Войти"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 46),
          child: Center(
            child: loading ? CircularProgressIndicator() : Container()
          )
        )
      ],
    );
  }

  Widget _buildIndicator(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Личный кабинет"),
      ),
      body: BlocBuilder(
        bloc: widget.userBloc,
        builder: (context, state){
          if (state is Loading){
            return _buildIndicator();
          } else if (state is Login){
            return _buildLogin();
          } else if (state is LoadingForLogin){
            return _buildLogin(loading: true);
          } else if (state is Authenticated){
            return _buildAuthenticated(state);
          }
          return Container();
        },
      )
    );
  }

}
			