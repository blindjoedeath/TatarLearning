import 'package:app/blocs/what_is_game/what_is_game_builder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'home_builder.dart';
import 'home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import 'home_event.dart';


class HomeScreen extends StatefulWidget{

  final HomeBloc homeBloc;

  const HomeScreen({@required this.homeBloc});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}


class _HomeScreenState extends State<HomeScreen> {

  String _pressedItemTag;
  bool withHero = false;

  void _show(Widget Function() builder)async{
    WidgetsBinding.instance.addPostFrameCallback((d) async{
      await Navigator.push(context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => Hero(
            tag: _pressedItemTag,
            child: WhatIsGameBuilder()
          ),
          transitionsBuilder: (c, anim, a2, child) => FadeTransition(
            opacity: CurvedAnimation(
              curve: Curves.fastOutSlowIn,
              parent: anim,
            ),
            child: child
          ),
          transitionDuration: Duration(milliseconds: 350),
        )
      );
    });
  } 

  void _itemPressed(String withTag, HomeEvent Function() builder){
    _pressedItemTag = withTag;
    widget.homeBloc.add(builder());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: widget.homeBloc,
      builder: (context, state){
        if (state is ShowWhatIsGame){
          widget.homeBloc.add(Showed());
          _show(() => WhatIsGameBuilder());
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
              HomeGridItem(
                withHero: withHero,
                itemIndex: 0,
                color: Colors.green,
                title: "Что это?",
                subtitle: "Нәрсә бу?",
                onTap: (tag) => _itemPressed(tag, () => WhatIsGamePressed()),
              ),
              HomeGridItem(
                withHero: withHero,
                itemIndex: 1,
                color: Colors.purple,
                title: "Что это?",
                subtitle: "Нәрсә бу?",
                onTap: (tag) => _itemPressed(tag, () => WhatIsGamePressed()),
              ),
            ],
          )
        );
      }
    );
  }

}
			

class HomeGridItem extends StatelessWidget{

  final String title;
  final String subtitle;
  final Color color;
  final bool withHero;
  final int itemIndex;
  final void Function(String) onTap;

  const HomeGridItem({@required this.title, @required this.color, @required this.itemIndex,
                      @required this.subtitle, @required this.onTap, @required this.withHero});

  String get _heroTag => "whatIsGame $itemIndex";

  Widget _buildItem(BuildContext context){
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            color: color,
            child: GridTile(
              footer: GridTileBar(
                title: Text(title, 
                  style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.white70
                  ),),
                subtitle: Text(subtitle, 
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
              onTap: () => onTap(_heroTag)
            )
          )
        ]
      )
    );
  }
  

  @override
  Widget build(BuildContext context) { 
    return Padding(
      padding: EdgeInsets.all(20),
      child: Material(
        elevation: 4,
        color: Colors.transparent,
        child: withHero ? Hero(
          tag: _heroTag,
          child: _buildItem(context)
        ) : _buildItem(context)
      )
    );
  }

}