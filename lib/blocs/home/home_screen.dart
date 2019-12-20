import 'package:app/blocs/what_is_game/what_is_game_builder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'home_builder.dart';
import 'home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import 'home_event.dart';


class HomeScreen extends StatelessWidget {

  final HomeBloc homeBloc;

  bool withHero = false; 

  HomeScreen({@required this.homeBloc});


  Widget _buildGridTile(BuildContext context){
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            color: Colors.green,
            child: GridTile(
              footer: GridTileBar(
                title: Text("Что это?", 
                  style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.white70
                  ),),
                subtitle: Text("Нәрсә бу?", 
                  style: Theme.of(context).textTheme.subtitle.copyWith(
                    color: Colors.white60
                  ),),
              ),
              child: Container(
                padding: EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                child: Icon(MdiIcons.crosshairsQuestion,
                  color: Colors.white70,
                  size: 80,
                )
              )
            )
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => homeBloc.add(WhatIsGamePressed())
            )
          )
        ]
      )
    );
  }


  Widget _buildGridItem(BuildContext context, {bool withHero}){
    return Padding(
      padding: EdgeInsets.all(20),
      child: Material(
        elevation: 4,
        color: Colors.transparent,
        child: withHero ? Hero(
            tag: "whatIsHero",
            child: _buildGridTile(context)
          ) : Container(
            child: _buildGridTile(context)
          )  
      )
    );
  }

  void _showWhatIsGame(BuildContext context)async{
    await Navigator.push(context,
      PageRouteBuilder(
      pageBuilder: (c, a1, a2) => WhatIsGameBuilder(
        ),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(
          opacity: CurvedAnimation(
            curve: Curves.fastOutSlowIn,
            parent: anim,
          ),
          child: child)
          ,
        transitionDuration: Duration(milliseconds: 350),
      )
    );
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc,
      builder: (context, state){
        if (state is ShowWhatIsGame){
          homeBloc.add(Showed());
          WidgetsBinding.instance.addPostFrameCallback((d) => _showWhatIsGame(context));
        }
        if (state is HomeDefaultState){
          withHero = state.withHeros;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Меню"),
            backgroundColor: Colors.blue,
          ),
          body: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3/4
            ),
            children: <Widget>[
              _buildGridItem(context,
                withHero: withHero
              )
            ],
          )
        );
      }
    );
  }

}
			