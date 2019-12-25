import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/user_repository.dart';
import 'package:dioc/dioc.dart';

import 'user_screen.dart';
import 'user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBuilder extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _UserBuilderState();

}

class _UserBuilderState extends State<UserBuilder>{

  UserBloc userBloc;

  @override
  void initState() {
    AppDependencyRepository
      .repositoriesContainer
      .register<UserRepository>((c) => UserRepository(), defaultMode: InjectMode.singleton);

    userBloc = UserBloc(
      userRepository: AppDependencyRepository.repositoriesContainer.get<UserRepository>()
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    AppDependencyRepository.repositoriesContainer.unregister<UserRepository>();
    userBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>.value(
      value: userBloc,
      child: UserScreen(
        userBloc: userBloc,
      ),
    );
  }

}
			