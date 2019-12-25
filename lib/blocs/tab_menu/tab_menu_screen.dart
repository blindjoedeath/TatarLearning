import 'dart:async';

import 'package:app/blocs/home/home_builder.dart';
import 'package:app/blocs/search/search_builder.dart';
import 'package:app/blocs/user/user_builder.dart';

import 'tab_menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tab_menu_state.dart';
import 'tab_menu_event.dart';


class TabMenuScreen extends StatelessWidget {

  final TabMenuBloc menuBloc;

  const TabMenuScreen({@required this.menuBloc});


  Widget _buildScaffold(BuildContext context, TabMenuState state){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: state is SearchTab ? SearchBuilder() : 
            state is UserTab ? UserBuilder() : HomeBuilder(),
      bottomNavigationBar: MenuNavigationBar(
        menuBloc: menuBloc,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<TabMenuBloc, TabMenuState>(
      bloc: menuBloc,
      builder: (context, state){
        if (state is WaitHeroTransition){
          return Hero(
            tag: "welcomeHero",
            child: _buildScaffold(context, state)
          );
        }
        return _buildScaffold(context, state);
      }
    );
  }
}


class MenuNavigationBar extends StatefulWidget{

  final TabMenuBloc menuBloc;

  const MenuNavigationBar({@required this.menuBloc}): assert(menuBloc != null);

  @override
  State<StatefulWidget> createState() => _MenuNavigationBarState();
}

class MenuSection{
  TabMenuEvent eventOnTap;
  BottomNavigationBarItem navigationItem;

  MenuSection({@required this.eventOnTap, @required this.navigationItem})
   : assert(eventOnTap != null), assert(navigationItem != null);
}

class _MenuNavigationBarState extends State<MenuNavigationBar>{

  int _currentIndex = 0;
  List<MenuSection> _menuSections = List<MenuSection>();

  @override
  void initState() {
    var home = MenuSection(
      eventOnTap: HomeTabPressed(),
      navigationItem: BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
    );

    var admin = MenuSection(
      eventOnTap: UserTabPressed(),
      navigationItem: BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        title: Text('User'),
      ),
    );

    var search = MenuSection(
      eventOnTap: SearchTabPressed(),
      navigationItem: BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('Search'),
      ),
    );
    _menuSections.add(home);
    _menuSections.add(admin);
    _menuSections.add(search);

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    var event = _menuSections[index].eventOnTap;
    widget.menuBloc.add(event);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: _onItemTapped,
      items: _menuSections.map((section) => section.navigationItem).toList(),
      currentIndex: _currentIndex
    );
  }
}
