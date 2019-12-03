import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bottom_area_avoider.dart';
import 'tatar_key_row.dart';
import 'tatar_themes.dart';
import 'tatar_input.dart';

class TatarKeyboard extends StatefulWidget {
  final Widget child;
  final bool autoScroll;
  final List<TatarInput> tatarInputs;

  const TatarKeyboard({@required this.child, @required this.tatarInputs, this.autoScroll = true})
    : assert(child != null), 
      assert(tatarInputs != null);

  @override
  _TatarKeyboardState createState() => _TatarKeyboardState();
}

class _TatarKeyboardState extends State<TatarKeyboard> with WidgetsBindingObserver {
  List<TatarInput> _inputs;
  TatarInput _currentInput;
  OverlayEntry _overlayEntry;
  double _offset = 0;

  bool get _isShowing {
    return _overlayEntry != null;
  }

  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    _inputs = widget.tatarInputs;
    _startListeningFocus();
    super.initState();
  }

  clearNodes() {
    _dismissListeningFocus();
    _inputs = null;
  }

  _clearFocus() {
    _currentInput.focusNode.unfocus();
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<Null> _focusNodeListener() async {
    bool hasFocusFound = false;
    _inputs.forEach((input) {
      if (input.focusNode.hasFocus) {
        _currentInput = input;
        hasFocusFound = true;
        return;
      }
    });
    _focusChanged(hasFocusFound);
  }

  _focusChanged(bool showBar) {
    if (showBar && !_isShowing) {
      _insertOverlay();
    } else if (!showBar && _isShowing) {
      _removeOverlay();
    } else if (showBar && _isShowing) {
      _overlayEntry.markNeedsBuild();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOffset();
    });
  }

  @override
  void didChangeMetrics() {
    if (Platform.isAndroid) {
      final value = WidgetsBinding.instance.window.viewInsets.bottom;
      if (value > 0) {
        _onKeyboardChanged(true);
        isKeyboardOpen = true;
      } else {
        isKeyboardOpen = false;
        _onKeyboardChanged(false);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOffset();
    });
  }

  _startListeningFocus() {
    _inputs
      .forEach((input) => input.focusNode.addListener(_focusNodeListener));
  }

  _dismissListeningFocus() {
    _inputs
      .forEach((input) => input.focusNode.removeListener(_focusNodeListener));
  }

  void _insertOverlay() {
    OverlayState os = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) {
      var theme = TatarKeyboardTheme.of(context);
      var width = MediaQuery.of(context).size.width;
      return AnimatedPositioned(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
        bottom: _isShowing ? MediaQuery.of(context).viewInsets.bottom :
                             MediaQuery.of(context).viewInsets.bottom -
                            TatarKeyboardTheme.of(context).keyboardHeight,
        left: 0,
        right: 0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            SizedBox(
              height: theme.keyboardHeight,
              width: width,
              child: Material(
                color: theme.backgroundColor
              )
            ),
            SizedBox(
              height: theme.keyboardHeight * 2,
              width: width,
              child: Material(
                color: Colors.transparent,
                child: _buildBar()
              ),
            )
          ],
        )
      );
    });
    os.insert(_overlayEntry);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  _updateOffset() {
    
    if (!mounted) {
      return;
    }

    if (!_isShowing) {
      setState(() {
        _offset = 0.0;
      });
      return;
    }

    double newOffset = TatarKeyboardTheme.of(context).keyboardHeight; 

    newOffset += MediaQuery.of(context)
        .viewInsets
        .bottom;

    if (_offset != newOffset) {
      setState(() {
        _offset = newOffset;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (state == AppLifecycleState.paused) {
        FocusScope.of(context).requestFocus(FocusNode());
        _focusChanged(false);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    clearNodes();
    _removeOverlay();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  var isKeyboardOpen = false;

  _onKeyboardChanged(bool isVisible) {
    if (!isVisible) {
      _clearFocus();
    }
  }

  _writeCharacter(String character){
    var controller = _currentInput.textEditingController;
    var end = controller.selection.end;
    var preffix = controller.text.substring(0, end);
    var suffix = controller.text.substring(end);
    var text = preffix + character + suffix;
    var selection = new TextSelection.fromPosition(
        new TextPosition(offset: end+1),
      );
    controller.value = controller.value.copyWith(
      text: text,
      selection: selection
    );
  }

  Widget _buildBar() {
    return SizedBox(
      height: TatarKeyboardTheme.of(context).keyboardHeight,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        top: false,
        bottom: false,
        child: TatarKeysRow(
          onKeyTapped: _writeCharacter,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.maxFinite,
        child: BottomAreaAvoider(
          areaToAvoid: _offset, autoScroll: widget.autoScroll, child: widget.child),
      ),
    );
  }
}