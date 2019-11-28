import 'dart:wasm';

import 'package:app/shared/entity/language.dart';
import 'package:app/tatar_keyboard/tatar_input.dart';
import 'package:app/tatar_keyboard/tatar_keyboard_impl.dart';

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

    var node = FocusNode();
    var controller = TextEditingController();

    return Scaffold(
      appBar: SearchAppBar(
        height: 150,
        searchBloc: searchBloc,
      ),
      body: TatarKeyboard(
        tatarInputs: [
          TatarInput(
            focusNode: node,
            textEditingController: controller
          )
        ],
        child: Column(
          children: <Widget>[
            Center(
              child: TextField(
                focusNode: node,
                controller: controller,
                keyboardAppearance: Brightness.light,
                autocorrect: false,
                ),
            ),
          ],
        ),
      )
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget{

  final double height;
  final SearchBloc searchBloc;

  const SearchAppBar({@required this.height, @required this.searchBloc})
   : assert(height != null), assert(searchBloc != null);

  @override
  Widget build(BuildContext context) {
    return FromToLanguageRow(
      searchBloc: searchBloc,
    );
  }
  
   @override
  Size get preferredSize => Size.fromHeight(height);
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

  ValueNotifier<List<String>> _langs;

  @override
  initState(){
    _langs = ValueNotifier(["Русский", "Татарский"]);

    if(widget.searchBloc.state.searchLangage == Language.Tatar){
      _langs.value = _langs.value.reversed.toList();
    }
    super.initState();
  }

  _buildLanguageText({@required int index}){
    return ValueListenableBuilder<List<String>>(
      valueListenable: _langs,
      builder: (context, value, child){
        return Text(value[index]);
      },
    );
  }

  _onPressed(){
    _langs.value = _langs.value.reversed.toList();
    _langs.notifyListeners();
    widget.searchBloc.add(SearchLanguageChanged());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
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
                    SizedBox(width: 20),
                    CompareArrowsButton(
                      onPressed: _onPressed,
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                Expanded(
                  child: _buildLanguageText(index: 1),
                ),
              ],
            )
          )
        ],
      )
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
          child: RotationTransition(
            turns: _animation,
            child: Icon(
              Icons.compare_arrows,
              color: _isPressed ? Colors.black54 : Color.lerp(Colors.black, Colors.black54, math.pow(1 - _controller.value, 0.2))
            ),
          ),
          onPanDown: (e) => this.setState((){
            _isPressed = true;
          }),
          onPanEnd: (e) => this.setState((){
            _isPressed = false;
            _onPressed();
          }),
        );
      },
    );
  }

}