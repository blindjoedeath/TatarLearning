import 'search_bloc.dart';
import 'package:flutter/material.dart';
import 'search_state.dart';
import 'search_event.dart';


class SearchTabBarSliver extends StatelessWidget {

  final SearchBloc searchBloc;
  
  final TabController tabController;
  
  const SearchTabBarSliver({@required this.searchBloc, @required this.tabController});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchTabBarPersistentHeaderDelegate(
        searchBloc: searchBloc,
        tabController: tabController
      ),
    );
  }

}

class SearchTabBar extends StatefulWidget{

  final SearchBloc searchBloc;

  final TabController tabController;

  double get height{
    var state = createElement().state as _SearchTabBarState;
    state.initState();
    return state.preferredSize?.height ?? 48;
  }

  const SearchTabBar({@required this.searchBloc, @required this.tabController});

  @override
  State<StatefulWidget> createState() => _SearchTabBarState();
}

class _SearchTabBarState extends State<SearchTabBar> with SingleTickerProviderStateMixin{
  TabController _tabController;
  TabBar _tabBar;

  void _onPressed(int index){
    var searchType = index == 0 ? SearchType.Global : SearchType.Local;
    widget.searchBloc.add(SearchTypeChanged(searchType: searchType));
  }

  Size get preferredSize{
    return _tabBar?.preferredSize;
  }

  @override
  void initState() {
    _tabController = widget.tabController;

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
  final TabController tabController;

  SearchTabBarPersistentHeaderDelegate({@required this.searchBloc, @required this.tabController});


  double _heightValue;
  double get _height{
    if(_heightValue == null){
      _heightValue = SearchTabBar(
        searchBloc: searchBloc,
        tabController: tabController,
      ).height;
    }
    return _heightValue;
  }
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: SearchTabBar(
        searchBloc: searchBloc,
        tabController: tabController,
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