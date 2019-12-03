import 'dart:wasm';

import 'package:app/shared/entity/language.dart';
import 'package:app/tatar_keyboard/tatar_input.dart';
import 'package:app/tatar_keyboard/tatar_keyboard_impl.dart';
import 'package:flutter/gestures.dart';
import 'package:statusbar/statusbar.dart';

import 'search_app_bar.dart';
import 'search_tab_bar.dart';
import 'search_builder.dart';
import 'search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';
import 'search_event.dart';
import 'dart:math' as math;


class SearchScreen extends StatefulWidget{

  final SearchBloc searchBloc;

  const SearchScreen({@required this.searchBloc});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();

}


class _SearchScreenState extends State<SearchScreen> {

  FocusNode _tatarFocusNode;
  FocusNode _rusFocusNode;
  ScrollController _scrollController;
  TextEditingController _textEditingController;


  void _disposeNode(FocusNode node){
    node?.unfocus();
    node?.removeListener(_nodeListener);
    node?.dispose();
  }

  @override
  void dispose() {
    _disposeNode(_tatarFocusNode);
    _disposeNode(_rusFocusNode);

    _scrollController?.dispose();

    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textEditingController = new TextEditingController();

    _tatarFocusNode = FocusNode();
    _rusFocusNode = FocusNode();

    _scrollController = ScrollController();

    _tatarFocusNode.addListener(_nodeListener);
    _rusFocusNode.addListener(_nodeListener);

    super.initState();
  }

  void _nodeListener(){
    if (_rusFocusNode.hasFocus || _tatarFocusNode.hasFocus){
      _scrollController.position.moveTo(0,
        duration: Duration(milliseconds: 1000)
      );
    }
  }

  FocusNode _getNode(Language language){
    var newNode = language == Language.Russian ? _rusFocusNode : _tatarFocusNode;
    var previousNode = language == Language.Russian ? _tatarFocusNode : _rusFocusNode;
    if (previousNode.hasFocus){
      FocusScope.of(context).requestFocus(newNode);
      previousNode.unfocus();
      previousNode.notifyListeners();
    }
    return newNode;
  }

  @override
  Widget build(BuildContext context) {

    return TatarKeyboard(
      child: CustomScrollView( 
        controller: _scrollController,
        slivers: [
          BlocBuilder<SearchBloc, SearchState>(
            bloc: widget.searchBloc,
            builder: (context, state){
              return SearchAppBarSliver(
                focusNode: _getNode(state.searchLanguage),
                searchBloc: widget.searchBloc,
                textEditingController: _textEditingController,
              );
            },
          ),
          SearchTabBarSliver(
            searchBloc: widget.searchBloc,
          ),
          SearchScreenBodySliver(
            searchBloc: widget.searchBloc,
          )
        ],
      ),
      tatarInputs: [
        TatarInput(
          focusNode: _tatarFocusNode,
          textEditingController: _textEditingController
        )
      ],
    );
  }
}

class SearchScreenBodySliver extends StatelessWidget{

  final SearchBloc searchBloc;
  final Widget child;

  const SearchScreenBodySliver({@required this.searchBloc, this.child});

  Widget _buildIndicator(){
    return SliverLayoutBuilder(
      builder: (context, constrainst){
        return SliverToBoxAdapter(
          child: SizedBox(
            height: constrainst.crossAxisExtent,
            child: Center(
              child: CircularProgressIndicator()
            )
          )
        );
      }
    );
  }

  Widget _buildTestList(SearchState state){
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index){
          var text = state.searchType == SearchType.Global ? "Global" : "Local";
          return ListTile(
            title: Text(text + " $index"),
          );
        },
        childCount: 100
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state){
        if(state is SearchLoading){
          return _buildIndicator();
        } else {
          return _buildTestList(state);
        }
      }
    );
  }

}