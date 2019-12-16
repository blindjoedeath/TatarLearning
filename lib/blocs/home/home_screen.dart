import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'home_builder.dart';
import 'home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import 'home_event.dart';


class HomeScreen extends StatelessWidget {

  final HomeBloc homeBloc;

  const HomeScreen({@required this.homeBloc});

  @override
  Widget build(BuildContext context) {
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
          Container(
            margin: EdgeInsets.all(20),
            child: ClipRRect(
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
                      onTap: () => print("tap"),
                    )
                  )
                ]
              )
            )
          )
        ],
      )
    );
  }

}
			