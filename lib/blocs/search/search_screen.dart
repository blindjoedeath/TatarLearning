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


class SearchScreen extends StatelessWidget {

  final SearchBloc searchBloc;

  const SearchScreen({@required this.searchBloc});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: SearchPersistentHeaderDelegate(
            statusBarHeight: MediaQuery.of(context).padding.top,
            searchBloc: searchBloc
          ),
        ),
        SearchTabBar(),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index){
            return ListTile(
              title: Text("text"),
            );
          },
          childCount: 10),
        )
      ],
    );
  }
}

class SearchTabBar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SearchTabBarState();
}

class _SearchTabBarState extends State<SearchTabBar> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: <Widget>[
        Tab(text: "text",),
        Tab(text: "text",),
        Tab(text: "text",)
      ],
      controller: TabController(
        length: 3,    
        vsync: this
      ),
    );
  }

}


class SearchPersistentHeaderDelegate extends SliverPersistentHeaderDelegate{

  final SearchBloc searchBloc;

  final double statusBarHeight;

  double searchBarHeight = 56;

  double fromToHeight = 50;

  SearchPersistentHeaderDelegate({@required this.searchBloc, @required this.statusBarHeight});

  _buildLanguageRow(){
    return FromToLanguageRow(
      searchBloc: searchBloc,
    );
  }

  _buildSearchBar(){
    return Container(
      height: 40,
      padding: EdgeInsets.only(right: 12, left: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          shadowColor: Colors.black,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Icon(
                  Icons.search, 
                  color: Colors.black45
                ),
              ),
              BlocBuilder<SearchBloc, SearchState>(
                bloc: searchBloc,
                builder: (context, state){
                  return Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: state.searchLangage == Language.Russian ? "Поиск" : "Эзләнү",
                      ),
                    )
                  );
                },
              )
            ],
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    print(shrinkOffset);
    StatusBar.color(Theme.of(context).primaryColor);
    var shrinkRatio = shrinkOffset / fromToHeight;
    shrinkRatio = shrinkRatio > 1 ? 1 : math.pow(shrinkRatio, 0.5);
    return SafeArea(
      child: Material(
        elevation: 4,
        shadowColor: Colors.black,
        color: Theme.of(context).primaryColor,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 12, bottom: 0),
                child: SizedBox(
                  height: fromToHeight - 12,
                  child: Opacity(
                    opacity: 1-shrinkRatio,
                    child: _buildLanguageRow()
                  )
                )
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 8, bottom: 12 - shrinkRatio * 4),
                child: _buildSearchBar()
              )
            )
          ],
        )
      )
    );
  }

  @override
  double get maxExtent => statusBarHeight + searchBarHeight + fromToHeight + 10;

  @override
  double get minExtent => statusBarHeight + searchBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class FromToLanguageRow extends StatefulWidget {
  final SearchBloc searchBloc;

  const FromToLanguageRow({
    Key key,
    @required this.searchBloc
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FromToLanguageRow();
}

class _FromToLanguageRow extends State<FromToLanguageRow>{

  @override
  initState(){
    super.initState();
  }

  _buildLanguageText({@required int index}){
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: widget.searchBloc,
      builder: (context, state){
        var langs = ["Русский", "Татарский"];
        if (state.searchLangage == Language.Tatar){
          langs = langs.reversed.toList();
        }
        return Text(langs[index],
          style: DefaultTextStyle.of(context).style.copyWith(
            color: Colors.white,
            fontSize: 15
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        Expanded(
          child: Align(
            child: _buildLanguageText(index: 0),
            alignment: Alignment.centerRight,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children:[
            CompareArrowsButton(
              onPressed: () => widget.searchBloc.add(SearchLanguageChanged()),
            ),
          ],
        ),
        Expanded(
          child: _buildLanguageText(index: 1),
        ),
      ],
    );
  }

}

class CompareArrowsButton extends StatefulWidget{

  final void Function() onPressed;

  const CompareArrowsButton({@required this.onPressed}) : assert(onPressed != null);

  @override
  State<StatefulWidget> createState() => _CompareArrowsButtonState();

}

class _CompareArrowsButtonState extends State<CompareArrowsButton> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation _animation;
  bool _isPressed = false;

  @override
  void initState() {
    _controller = new AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this
    );
    _controller.forward();

    _animation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        curve: Curves.linearToEaseOut,
        parent: _controller
      )
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onPressed(){
    if (_controller.isAnimating){
      return;
    }
    if (_controller.isCompleted){
      _controller.reset();
    }
    _controller.forward();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child){
        return GestureDetector(
          child: Container(
            height: double.infinity,
            width: 60,
            color: Colors.transparent,
            child: RotationTransition(
              turns: _animation,
              child: Icon(
                Icons.compare_arrows,
                color: _isPressed ? Colors.white24 : Color.lerp(Colors.white, Colors.white24, math.pow(1 - _controller.value, 0.2))
              ),
            ),
          ),
          onPanDown: (e) => this.setState((){
            _isPressed = true;
          }),
          onPanEnd: (e) => this.setState((){
            _isPressed = false;
            _onPressed();
          }),
          onPanCancel: () => this.setState((){
            _isPressed = false;
            _onPressed();
          }),
        );
      },
    );
  }

}