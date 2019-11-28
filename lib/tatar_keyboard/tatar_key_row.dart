import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'tatar_themes.dart';
import 'dart:async';

const List<String> _tatarCharacters = ["ә", "җ", "ң", "ө", "ү", "һ"];

class _TatarKeyBase extends StatefulWidget{

  final Widget child;
  final bool isSelected;
  final bool isIncreasing;
  final Color overrideColor;
  const _TatarKeyBase({@required this.child, this.overrideColor, this.isSelected = false, this.isIncreasing = true});

  @override
  createState() => _TatarKeyBaseState();
}

class _TatarKeyBaseState extends State<_TatarKeyBase>{

  @override
  Widget build(BuildContext context){

    var margin = TatarKeyboardTheme.keyMargin;
    var topMargin = TatarKeyboardTheme.keyTopMargin;
    var theme = TatarKeyboardTheme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 1,
            offset: const Offset(0, 1)
          )
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.only(left: margin, right: margin, top: topMargin),
      width: widget.isSelected && widget.isIncreasing ? theme.keySize.width * 1.1 : theme.keySize.width,
      height: widget.isSelected && widget.isIncreasing ? theme.keySize.height * 2.2 : theme.keySize.height,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            alignment: widget.isSelected && widget.isIncreasing ? Alignment.topCenter : Alignment.center,
            child: Transform.scale(
              scale: widget.isSelected && widget.isIncreasing ? 1.2 : 1,
              child: Container(
                child: widget.child,
                margin: EdgeInsets.only(top: widget.isSelected && widget.isIncreasing ? theme.keySize.height * 0.1 : 0),
              ),
            ),
            color: widget.overrideColor ?? theme.keyColor,
          ),
        ),
      ) 
        );
  }
}

class _TatarKey extends StatefulWidget{

  final String character;
  final bool isSelected;
  final ValueNotifier<_CapsState> capsState;

  const _TatarKey({@required this.character, this.isSelected = false, @required this.capsState})
    : assert(character != null);

  @override
  createState() => _TatarKeyState();
}

class _TatarKeyState extends State<_TatarKey>{

  String character;

  @override
  Widget build(BuildContext context) {
    return _TatarKeyBase(
      child: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: ValueListenableBuilder(
          valueListenable: widget.capsState,
          builder: (context, capsState, someWidget){
            character = capsState == _CapsState.Disabled ? widget.character.toLowerCase()
                                                         : widget.character.toUpperCase();                                                         
            return Text(
              character,
              textAlign: TextAlign.center,
              style: TatarKeyboardTheme.of(context).textStyle
            );
          },
        )
      ),
      isSelected: widget.isSelected,
    );
  }
}
enum _CapsState{Disabled, Single, Enabled}
class _CapsKey extends StatefulWidget{

  final ValueNotifier<_CapsState> capsState;

  const _CapsKey({@required this.capsState});

  @override
  createState() => _CapsKeyState();
}

class _CapsKeyState extends State<_CapsKey>{

  bool _isSelected;
  bool _isTapped;
  bool _isDoubleTapped;
  Timer _timer;
  Color _keyColor;
  Icon _icon;

  @override
  void initState() {
    _isSelected = false;
    _isTapped = false;
    _isDoubleTapped = false;
    widget.capsState.addListener((){
      if(widget.capsState.value == _CapsState.Disabled){
        setState((){});
      }
    });
    super.initState();
  }

  void _changeState(_CapsState state){
    var capsState = widget.capsState;
    capsState.value = state;
    capsState.notifyListeners();
  }

  void _onDoubleTap(){
    _changeState(_CapsState.Enabled);
    _isDoubleTapped = true;
  }

  Color _inversedColor(Color color){
    return Color.fromARGB(255, 255 - color.red, 255 - color.green, 255 - color.blue);
  }

  void _setUpIcon(){
    var theme = TatarKeyboardTheme.of(context);
    var state = widget.capsState.value;
    var icon = state == _CapsState.Enabled ? MdiIcons.appleKeyboardCaps
                                        : MdiIcons.appleKeyboardShift;
    _keyColor = state == _CapsState.Disabled && !_isSelected ? theme.capsKeyColor : theme.selectedCapsColor;
    _icon = Icon(
      icon,
      color: theme.isDark && (state != _CapsState.Disabled || _isSelected)
                                                          ? _inversedColor(theme.textStyle.color)
                                                          : theme.textStyle.color,
      size: theme.textStyle.fontSize,
    );
  }

  void _runTimer(){
    _isTapped = true;
    _timer = Timer(Duration(milliseconds: 300), (){
      _isTapped = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = TatarKeyboardTheme.of(context);
    _setUpIcon();
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        _TatarKeyBase(
          child: _icon,
          isSelected: _isSelected,
          overrideColor: _keyColor,
          isIncreasing: false,
        ),
        Listener(
          child: Container(
            color: Colors.transparent,
            width: theme.keyGestureZone.width,
            height: theme.keyGestureZone.height,
          ),
          onPointerDown: (d){
            if(!_isTapped){
              _runTimer();
              setState(() {
                _isSelected = true;
              });
            } else{
              _onDoubleTap();
            }
          },
          onPointerUp: (d){
            if (widget.capsState.value == _CapsState.Disabled){
              _changeState(_CapsState.Single);
            } else if(_isDoubleTapped){
              _isDoubleTapped = false;
            } else {
              _changeState(_CapsState.Disabled);
            }
            setState(() {
              _isSelected = false;
            });
          },
          onPointerCancel: (d){
            setState(() {
              _isSelected = false;
            });
          },      
        ),
      ]
    );
  }

}

class TatarKeysRow extends StatefulWidget{

  final void Function(String) onKeyTapped;

  const TatarKeysRow({@required this.onKeyTapped}) : assert(onKeyTapped != null);

  @override
  createState() => _TatarKeysRowState();
}

class _KeyState{
  ValueNotifier<bool> isSelected;
  String character;
  _KeyState(this.isSelected, this.character);
}

class _TatarKeysRowState extends State<TatarKeysRow>{

  ValueNotifier<_CapsState> _state;
  List<_KeyState> _keyStates;
  double _keyGestureZoneWidth;

  @override
  void initState() {
    _keyStates = new List<_KeyState>.generate(_tatarCharacters.length, (index){
      return _KeyState(ValueNotifier(false), _tatarCharacters[index]);
    });
    _state = ValueNotifier(_CapsState.Disabled);
    super.initState();
  }

  void _onKeyTapped(String character){

    var capsed = _state.value == _CapsState.Disabled ? character : character.toUpperCase();
    if (_state.value == _CapsState.Single){
       _state.value = _CapsState.Disabled;
       _state.notifyListeners();
    }
    widget.onKeyTapped(capsed);
  }

  List<Widget> _buildKeys(){
    return List<Widget>.generate(_tatarCharacters.length, (index){
      return ValueListenableBuilder(
        valueListenable: _keyStates[index].isSelected,
        builder: (context, value, widget){
          return _TatarKey(
            character: _tatarCharacters[index],
            isSelected: value,
            capsState: _state,
          );
        }
      );
    });
  }

  void _tryGetNewKey(PointerEvent event, void Function(int) onSuccess){
    var dx = event.localPosition.dx;
    int index = dx >= 0 ? dx ~/ _keyGestureZoneWidth : -1;
    for (int i = 0; i < _keyStates.length; ++i){
      var selected = _keyStates[i].isSelected;
      if (selected.value && i != index){
        selected.value = false;
        selected.notifyListeners();
      }
    }
    if (0 <= index && index < _keyStates.length){
      onSuccess(index);
    }
  }

  void _selectKey(PointerEvent event){
    _tryGetNewKey(event, (index){
      var selected = _keyStates[index].isSelected;
      selected.value = true;
      selected.notifyListeners();
    });
  }

  void _tapKey(PointerEvent event){
    _tryGetNewKey(event, (index){
      var character = _keyStates[index].character;
      _onKeyTapped(character);
      var selected = _keyStates[index].isSelected;
      selected.value = false;
      selected.notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    _keyGestureZoneWidth = TatarKeyboardTheme.of(context).keyGestureZone.width;
    return Padding(
      padding: EdgeInsets.only(bottom: TatarKeyboardTheme.keyMargin),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _CapsKey(
                capsState: _state,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Listener(
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _buildKeys(),
                  ),
                  color: Colors.transparent
                ),
                onPointerDown: _selectKey,
                onPointerMove: _selectKey,
                onPointerUp: _tapKey,
                onPointerCancel: _tapKey,
              )
            ]
          ),
        ]
      )
    );
  }
}