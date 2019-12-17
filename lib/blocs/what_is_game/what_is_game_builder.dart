import 'what_is_game_screen.dart';
import 'what_is_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhatIsGameBuilder extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WhatIsGameBuilderState();

}

class _WhatIsGameBuilderState extends State<WhatIsGameBuilder>{

  WhatIsGameBloc whatIsGameBloc;

  @override
  void initState() {
    whatIsGameBloc = WhatIsGameBloc(
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    whatIsGameBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WhatIsGameBloc>.value(
      value: whatIsGameBloc,
      child: WhatIsGameScreen(
        whatIsGameBloc: whatIsGameBloc,
      ),
    );
  }

}
			