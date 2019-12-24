import 'package:flutter/material.dart';

class TatarInput{
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  const TatarInput({@required this.focusNode, @required this.textEditingController})
    : assert(focusNode != null),
      assert(textEditingController != null);
}