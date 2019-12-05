
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

    _textEditingController.removeListener(_textListener);
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

  void _nodeListener(){
    if (_rusFocusNode.hasFocus || _tatarFocusNode.hasFocus){
      _scrollController.position.moveTo(0,
        duration: Duration(milliseconds: 1000)
      );
    }
  }

  void _textListener(){
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
            tabController: _tabController,
          ),
          SearchScreenBodySliver(
            searchBloc: widget.searchBloc,
            tabController: _tabController,
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
  final TabController tabController;

  const SearchScreenBodySliver({@required this.searchBloc, @required this.tabController, this.child});

  Widget _buildIndicator(){
    return Center(
      child: CircularProgressIndicator()
    );
  }

  Widget _buildDefaultScreen(){
    return Center(
      child: Text("waiting")
    );
  }

  Widget _buildCardsList(List<WordCard> cards){
    return ListView.builder(
      addRepaintBoundaries: true,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(cards[index].word),
        );
      },
      itemCount: cards.length,
    );
  }

  Widget _buildTab({bool isGlobal}){
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state){
        if (state.isEmpty){
          return _buildDefaultScreen();
        }else if(state.isLoading){
          return _buildIndicator();
        } else{
          var cards = isGlobal ? state.globalCards : state.localCards;
          return _buildCardsList(cards);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: tabController,
        children: <Widget>[
          _buildTab(isGlobal: true),
          _buildTab(isGlobal: false)
        ],
      ),
    );
  }

}