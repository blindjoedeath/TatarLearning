
import 'dart:async';

import 'package:app/shared/entity/language.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/tatar_keyboard/tatar_input.dart';
import 'package:app/tatar_keyboard/tatar_keyboard_impl.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
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
  ValueNotifier _isHasFocus = ValueNotifier(false);
  SearchAppBarSliver _appBar;
  SearchTabBarSliver _tabBar;

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

  void _updateValueNotifier(ValueNotifier notifier, bool value){
    if (value != notifier.value){
      // because custom scroll rebuilds itself when has focus
      if (value){
        notifier.value = value;
      } else {
        WidgetsBinding.instance
          .addPostFrameCallback((_) => notifier.value = value);
      }
    }
  }

  void _updateIsEditing(){
    var value  = (_rusFocusNode.hasFocus || _tatarFocusNode.hasFocus)
                  && _textEditingController.text.isEmpty;
    _updateValueNotifier(_isEditing, value);
  }

  void _updateIsHasFocus(){
    var value  = _rusFocusNode.hasFocus || _tatarFocusNode.hasFocus;
    _updateValueNotifier(_isHasFocus, value);
  }

  String previousQuery;
  void _updateSearchHistory(){
    if (widget.searchBloc.state.isSearchDone){
      var query = _textEditingController.text.trim();
      if (query != previousQuery){
        previousQuery = query;
        widget.searchBloc.add(UserExploredSearchResult(
          query: query
        ));
      }
    }
  }
  
  void _unfocus(){
    _tatarFocusNode.unfocus();
    _rusFocusNode.unfocus();
    _updateIsEditing();
    _updateIsHasFocus();
    _updateSearchHistory();
  }

  void _nodeListener()async{
    _updateIsEditing();
    _updateIsHasFocus();
  }

  void _textListener(){
    var text = _textEditingController.text.trim();
    var event = SearchTextEdited(text: text);
    widget.searchBloc.add(event);
    _updateIsEditing();
    _updateIsHasFocus();
    if (text.isNotEmpty){
      _updateSearchHistory();
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
    return NotificationListener(
      child: TatarKeyboard(
        child: CustomScrollView( 
          controller: _scrollController,
          slivers: [
            BlocBuilder<SearchBloc, SearchState>(
              bloc: widget.searchBloc,
              builder: (context, state){
                _appBar = SearchAppBarSliver(
                  focusNode: _getNode(state.searchLanguage),
                  searchBloc: widget.searchBloc,
                  textEditingController: _textEditingController,
                );
                return _appBar;
              },
            ),
            ValueListenableBuilder(
              valueListenable: _isHasFocus,
              builder: (context, value, child){
                return BlocBuilder<SearchBloc, SearchState>(
                  bloc: widget.searchBloc,
                  builder: (context, state){
                    if (value || !state.isEmpty) {
                      _tabBar = SearchTabBarSliver(
                        searchBloc: widget.searchBloc,
                        tabController: _tabController,
                      );
                      return _tabBar;
                    }
                    return SliverToBoxAdapter(
                      child: Container()
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _isEditing,
              builder: (context, value, child){
                return SearchScreenBodySliver(
                  searchBloc: widget.searchBloc,
                  tabController: _tabController,
                  isEditing: value,
                  onCoverTap: _unfocus,
                );
              }
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
  final bool isEditing;

  const SearchScreenBodySliver({@required this.searchBloc, @required this.tabController,
                                 @required this.isEditing, @required this.onCoverTap});

  @override
  State<StatefulWidget> createState() => _SearchScreenBodySliver();

}

class _SearchScreenBodySliver extends State<SearchScreenBodySliver>{

  double _kListTileExtend = 48;

  Widget _buildIndicator(){
    return SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator()
      )
    );
  }

  Widget _buildDefaultScreenList(SearchState state){
    if (state.searchHistory != null){
      return ListView.builder(
        itemExtent: _kListTileExtend,
        itemBuilder: (context, index){
          if (index == 0 || index == 4){
            return ListTile(
              title: Text(index == 0 ? "Недавние" : "Популярные", 
                style: Theme.of(context).textTheme.headline,
              )
            );
          }
          var queries = state.searchHistory.value.reversed.toList();
          if (index-1 < queries.length){
            return ListTile(
              title: Text(queries[index-1]),
            );
          }
          return ListTile(
            title: Text("text"),
          );
        },
        itemCount: 8,
      );
    }
  return Container();
  }

  double _heightOfList(SearchState state, SliverConstraints constraints){
    var history = state.searchHistory.value.length;
    history = history > 0 ? history + 1 : history;
    var popular = 3;
    popular = popular > 0 ? popular + 1 : popular;
    var height = (history + popular) * _kListTileExtend;
    var minHeight = constraints.viewportMainAxisExtent - constraints.precedingScrollExtent + 1;
    return height > minHeight ? height : minHeight;
  }

  Widget _buildDefaultScreen(SearchState state){
    return SliverLayoutBuilder(
      builder: (context, constraints){
        return SliverToBoxAdapter(
          child: Container(
            height: _heightOfList(state, constraints),
            child: Stack(
              children: <Widget>[
                _buildDefaultScreenList(state),
                AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  color: widget.isEditing ? Colors.black45 : Colors.transparent,
                  child: GestureDetector(
                    onTap: widget.onCoverTap,
                  )
                )
              ],
            )
          )
        );
      }
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
          return _buildDefaultScreen(state);
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