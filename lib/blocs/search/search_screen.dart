
import 'dart:async';

import 'package:app/shared/entity/language.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/tatar_keyboard/tatar_input.dart';
import 'package:app/tatar_keyboard/tatar_keyboard_impl.dart';
import 'package:flutter/gestures.dart';
import 'package:statusbar/statusbar.dart';

import 'search_app_bar.dart';
import 'search_tab_bar.dart';
import 'search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';
import 'search_event.dart';


class SearchScreen extends StatefulWidget{

  final SearchBloc searchBloc;

  const SearchScreen({@required this.searchBloc});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();

}


class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin{

  FocusNode _tatarFocusNode;
  FocusNode _rusFocusNode;
  ScrollController _scrollController;
  TextEditingController _textEditingController;
  TabController _tabController;
  ValueNotifier _isEditing = ValueNotifier(false);

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

    _textEditingController?.removeListener(_textListener);
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textEditingController = new TextEditingController();
    _textEditingController.addListener(_textListener);

    _tatarFocusNode = FocusNode();
    _rusFocusNode = FocusNode();

    _scrollController = ScrollController();

    _tabController = TabController(
      initialIndex: widget.searchBloc.initialState.searchType == SearchType.Global ? 0 : 1,
      length: 2,    
      vsync: this
    );

    _tatarFocusNode.addListener(_nodeListener);
    _rusFocusNode.addListener(_nodeListener);

    super.initState();
  }

  void _updateIsEditing(){
    var value  = (_rusFocusNode.hasFocus || _tatarFocusNode.hasFocus)
                  && _textEditingController.text.isEmpty;
    if (value != _isEditing.value){
      // because custom scroll rebuilds itself when has focus
      if (value){
        _isEditing.value = value;
      } else {
        WidgetsBinding.instance
          .addPostFrameCallback((_) => _isEditing.value = value);
      }
    }
  }

  void _unfocus(){
    _tatarFocusNode.unfocus();
    _rusFocusNode.unfocus();
    _updateIsEditing();
  }

  void _nodeListener()async{
    _updateIsEditing();
  }

  void _textListener(){
    _updateIsEditing();
    var text = _textEditingController.text.trim();
    var event = SearchTextEdited(text: text);
    widget.searchBloc.add(event);
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
    return NotificationListener(
      child: TatarKeyboard(
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
            ValueListenableBuilder(
              valueListenable: _isEditing,
              builder: (context, value, child){
                if (value || !widget.searchBloc.state.isEmpty) {
                  return SearchTabBarSliver(
                    searchBloc: widget.searchBloc,
                    tabController: _tabController,
                  );
                }
                return SliverToBoxAdapter(
                  child: Container()
                );
              },
            ),
            SearchScreenBodySliver(
              searchBloc: widget.searchBloc,
              tabController: _tabController,
              isEditing: _isEditing,
              onCoverTap: _unfocus,
            )
          ],
        ),
        tatarInputs: [
          TatarInput(
            focusNode: _tatarFocusNode,
            textEditingController: _textEditingController
          )
        ],
      ),
      onNotification: (notification){
        if(notification is UserScrollNotification){
          _unfocus();
        }
        return false;
      },
    );
  }
}

class SearchScreenBodySliver extends StatefulWidget{

  final SearchBloc searchBloc;
  final TabController tabController;
  final void Function() onCoverTap;
  final ValueNotifier isEditing;

  const SearchScreenBodySliver({@required this.searchBloc, @required this.tabController,
                                 @required this.isEditing, @required this.onCoverTap});

  @override
  State<StatefulWidget> createState() => _SearchScreenBodySliver();

}

class _SearchScreenBodySliver extends State<SearchScreenBodySliver>{

  Widget _buildIndicator(){
    return SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator()
      )
    );
  }

  Widget _buildDefaultScreen(){
    return SliverFillRemaining(
      child: Stack(
        children: <Widget>[
          Center(
            child: Text("waiting")
          ),
          ValueListenableBuilder(
            valueListenable: widget.isEditing,
            builder: (context, editing, child){
              return AnimatedContainer(
                duration: Duration(milliseconds: 250),
                color: editing ? Colors.black45 : Colors.transparent,
                child: GestureDetector(
                  onTap: widget.onCoverTap
                )
              );
            }
          ),
        ],
      )
    );
  }

  Widget _buildListView({List<WordCard> cards}){
    if (cards == null){
      return Container();
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index){
          return ListTile(
            title: Text(cards[index].word)
          );
        },
        childCount: cards.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: widget.searchBloc,
      builder: (context, state){
        if (state.isEmpty){
          return _buildDefaultScreen();
        } else if (state.isLoading){
          return _buildIndicator();
        }
        return _buildListView(
          cards: state.searchType == SearchType.Global ?
                 state.globalCards : state.localCards
        );
      },
    );
  }
}