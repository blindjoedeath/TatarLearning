import 'dart:wasm';

import 'package:app/shared/entity/language.dart';
import 'package:app/tatar_keyboard/tatar_input.dart';
import 'package:app/tatar_keyboard/tatar_keyboard_impl.dart';
import 'package:flutter/gestures.dart';
import 'package:statusbar/statusbar.dart';

import 'search_builder.dart';
import 'search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';
import 'search_event.dart';
import 'dart:math' as math;



class SearchTabBarSliver extends StatelessWidget {

  final SearchBloc searchBloc;

  const SearchTabBarSliver({@required this.searchBloc});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchTabBarPersistentHeaderDelegate(
        searchBloc: searchBloc
      ),
    );
  }

}

class SearchTabBar extends StatefulWidget{

  final SearchBloc searchBloc;

  const SearchTabBar({@required this.searchBloc});

  @override
  State<StatefulWidget> createState() => _SearchTabBarState();
}

class _SearchTabBarState extends State<SearchTabBar> with SingleTickerProviderStateMixin{
  TabController _tabController;
  TabBar _tabBar;

  Size get preferredSize{
    return _tabBar?.preferredSize;
  }

  void _onPressed(int index){
    var searchType = index == 0 ? SearchType.Global : SearchType.Local;
    widget.searchBloc.add(SearchTypeChanged(searchType: searchType));
  }

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.searchBloc.initialState.searchType == SearchType.Global ? 0 : 1,
      length: 2,    
      vsync: this
    );

    _tabBar = TabBar(
      labelColor: Colors.blue,
      controller: _tabController,
      tabs: <Widget>[
        Tab(
          text: "Tatar Learning",
        ),
        Tab(
          text: "Ваш словарь",
        )
      ],
      onTap: _onPressed,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _tabBar;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

}

class SearchTabBarPersistentHeaderDelegate extends SliverPersistentHeaderDelegate{

  final SearchBloc searchBloc;

  double _heightValue;
  double get _height{
    if(_heightValue == null){
      var widget = SearchTabBar(
        searchBloc: searchBloc,
      );
      var state = widget.createElement().state as _SearchTabBarState;
      state.initState();
      _heightValue = state.preferredSize?.height ?? 48;
    }
    return _heightValue;
  }

  SearchTabBarPersistentHeaderDelegate({@required this.searchBloc});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: SearchTabBar(
        searchBloc: searchBloc,
      ),
      elevation: 4,
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}