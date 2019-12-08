import 'package:app/shared/entity/language.dart';
import 'package:flutter/services.dart';
import 'package:statusbar/statusbar.dart';

import 'search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';
import 'search_event.dart';
import 'dart:math' as math;


class SearchAppBarSliver extends StatelessWidget{

  final SearchBloc searchBloc;
  final FocusNode focusNode;
  final TextEditingController textEditingController;

  const SearchAppBarSliver({@required this.searchBloc, @required this.focusNode,
                            @required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchAppBarPersistentHeaderDelegate(
        statusBarHeight: MediaQuery.of(context).padding.top,
        searchBloc: searchBloc,
        focusNode: focusNode,
        textEditingController: textEditingController
      ),
    );
  }

}


class SearchAppBarPersistentHeaderDelegate extends SliverPersistentHeaderDelegate{

  final SearchBloc searchBloc;

  final double statusBarHeight;

  final FocusNode focusNode;

  final TextEditingController textEditingController;

  double _searchBarHeight = 56;

  double _fromToHeight = 50;

  SearchAppBarPersistentHeaderDelegate({@required this.searchBloc, @required this.statusBarHeight,
                                        @required this.focusNode, @required this.textEditingController});

  _buildLanguageRow(){
    return FromToLanguageRow(
      searchBloc: searchBloc,
    );
  }

  Widget _buildSearchBar(BuildContext context){
    return Container(
      height: 40,
      padding: EdgeInsets.only(right: 12, left: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Icon(
                  Icons.search, 
                  color: Colors.black45
                ),
              ),
              Expanded(
                child: TextField(
                  inputFormatters: [WhitelistingTextInputFormatter(
                    RegExp("[a-zA-zа-яА-Я ]"),
                  )],
                  textInputAction: TextInputAction.search,
                  scrollPadding: EdgeInsets.only(top: statusBarHeight + _searchBarHeight),
                  focusNode: focusNode,
                  autocorrect: false,
                  controller: textEditingController,
                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Поиск",
                  ),
                )
              )
            ],
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    StatusBar.color(Theme.of(context).primaryColor);
    var shrinkRatio = shrinkOffset / _fromToHeight;
    shrinkRatio = shrinkRatio > 1 ? 1 : math.pow(shrinkRatio, 0.5);
    return Material(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 12 + statusBarHeight, bottom: 0),
              child: SizedBox(
                height: _fromToHeight - 12,
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
              child: _buildSearchBar(context)
            )
          )
        ],
      )
    );
  }

  @override
  double get maxExtent => statusBarHeight + _searchBarHeight + _fromToHeight + 10;

  @override
  double get minExtent => statusBarHeight + _searchBarHeight;

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
        if (state.searchLanguage == Language.Tatar){
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
                color: _isPressed ? Colors.white24 : Color.lerp(Colors.white, Colors.white24, math.pow(1 - _controller.value, 0.7))
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