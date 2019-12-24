
import 'dart:async';

import 'package:app/blocs/word_card_detail/word_card_detail_builder.dart';
import 'package:app/shared/entity/language.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/widget/tatar_keyboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

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

  void _disposeNode(FocusNode node){
    node?.unfocus();
    node?.removeListener(_nodeListener);
    node?.dispose();
  }

  @override
  void dispose() {
    _disposeNode(_tatarFocusNode);
    _disposeNode(_rusFocusNode);

    _textEditingController?.removeListener(_textListener);
    _textEditingController?.dispose();

    _tabController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _textEditingController = new TextEditingController();
    _textEditingController.text = widget.searchBloc.state.searchText;
    _textEditingController.addListener(_textListener);
    
    _tatarFocusNode = FocusNode();
    _rusFocusNode = FocusNode();

    _tabController = TabController(
      initialIndex: widget.searchBloc.state.searchType == SearchType.Global ? 0 : 1,
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
    if (!widget.searchBloc.state.isEmpty){
      var query = _textEditingController.text.trim();
      if (query != previousQuery && query.isNotEmpty){
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

  bool get _isSearchPressed{
    var hasFocus = _tatarFocusNode.hasFocus || _rusFocusNode.hasFocus;
    var selection = _textEditingController.value.selection;
    return !hasFocus && selection.baseOffset == -1 && selection.extentOffset == -1
            && _textEditingController.text.isNotEmpty;
  }

  void _textListener(){
    var text = _textEditingController.text.trim();
    var event = SearchTextEdited(
      text: text,
      isLastCharacter: _isSearchPressed
    );
    widget.searchBloc.add(event);
    _updateIsEditing();
    _updateIsHasFocus();
    if (_isSearchPressed){
      WidgetsBinding.instance.addPostFrameCallback((_) =>
        _updateSearchHistory()); 
    }
  }

  FocusNode _getNode(Language language){
    var newNode = language == Language.Russian ? _rusFocusNode : _tatarFocusNode;
    var previousNode = language == Language.Russian ? _tatarFocusNode : _rusFocusNode;
    if (previousNode.hasFocus){
      if (!newNode.hasFocus){
        FocusScope.of(context).requestFocus(newNode);
      }
      previousNode.unfocus();
      previousNode.notifyListeners();
    }
    return newNode;
  }

  @override
  Widget build(BuildContext context) {
    _scrollController = PrimaryScrollController.of(context);
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
            SearchTabBarSliver(
              searchBloc: widget.searchBloc,
              tabController: _tabController,
            ),
            ValueListenableBuilder(
              valueListenable: _isEditing,
              builder: (context, value, child){
                return SearchScreenBodySliver(
                  searchBloc: widget.searchBloc,
                  tabController: _tabController,
                  isEditing: value,
                  onCoverTap: _unfocus,
                  onPreviousQuery: (query){
                    _textEditingController.text = query;
                    _unfocus();
                  },
                );
              }
            ),
             SliverLayoutBuilder(
              builder: (context, constraints){
                var height = constraints.viewportMainAxisExtent -
                      constraints.precedingScrollExtent + 1;
                height = height > 0 ? height : 0;
                return SliverToBoxAdapter(
                  child: Container(
                    height: height,
                  )
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
  final void Function(String) onPreviousQuery;
  final void Function() onCoverTap;
  final bool isEditing;

  const SearchScreenBodySliver({@required this.searchBloc, @required this.tabController,
                                 @required this.isEditing, @required this.onCoverTap,
                                 @required this.onPreviousQuery});

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
      var quieriesCount = state.searchHistory.value.length;
      return ListTileTheme(
        selectedColor: Colors.black45,
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            height: 0,
            color: Colors.grey.withAlpha(200)
          ),
          itemBuilder: (context, index){
            if (index == 0 || index == 4){
              return ListTile(
                title: Text(index == 0 ? "Недавние" : "Популярные", 
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            }
            var queries = state.searchHistory.value.reversed.toList();
            if (index-1 < quieriesCount){
              var query = queries[index-1];
              return ListTile(
                title: Text(query,
                  style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Colors.black54),
                ),
                onTap: () => widget.onPreviousQuery(query)
              );
            }
            return ListTile(
              title: Text("text $index"),
            );
          },
          itemCount: quieriesCount > 0 ? quieriesCount+1 : 0,
        )
      );
    }
    return Container();
  }

  double _heightOfList(SearchState state, SliverConstraints constraints){
    var history = state.searchHistory.value.length;
    history = history > 0 ? history + 1 : history;
    var popular = 0;
    popular = popular > 0 ? popular + 1 : popular;
    popular = 0;
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
                  color: widget.isEditing ? Colors.black45 : null,
                  child: widget.isEditing ? GestureDetector(
                    onTap: widget.onCoverTap,
                  ) : null
                )
              ],
            )
          )
        );
      }
    );
  }

  Widget _buildListView({List<WordCard> cards}){
    if (cards == null || cards.isEmpty){
      return SliverFillRemaining(
        child: Center(
          child: Text("Ничего не найдено.",
            style: Theme.of(context).textTheme.display1
          )
        )
      );
    }
    return ListTileTheme(
      selectedColor: Colors.black45,
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index){
            var card = cards[index];
            return ListTile(
              title: Text(card.word),
              subtitle: Text(card.translates[0]),
              leading: Padding(
                padding: EdgeInsets.all(6),
                child: Hero(
                  tag: "card-${card.translates.hashCode}",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: FadeInImage(
                      image: NetworkImage(card.imageUrl),
                      placeholder: AssetImage("images/100.png"),
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    )
                  ),
                )
              ),
              onTap: ()async{
                await Navigator.push(context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => WordCardDetailBuilder(
                       wordCard: card,
                     ),
                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(
                      opacity: CurvedAnimation(
                        curve: Curves.fastOutSlowIn,
                        parent: anim,
                      ),
                      child: child)
                      ,
                    transitionDuration: Duration(milliseconds: 350),
                  )
                );
                widget.searchBloc.add(ReturnedToView());
              },
            );
          },
          childCount: cards.length,
        ),
      )
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