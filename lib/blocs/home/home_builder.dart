import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/intro_showed_repository.dart';
import 'package:dioc/dioc.dart';

import 'home_screen.dart';
import 'home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBuilder extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomeBuilderState();

}

class _HomeBuilderState extends State<HomeBuilder>{

  HomeBloc homeBloc;

  @override
  void initState() {
    AppDependencyRepository
      .repositoriesContainer.register<IntroShowedRepository>(
        (c) => IntroShowedRepository(), defaultMode: InjectMode.singleton
      );

    homeBloc = HomeBloc(
      introShowedRepository: AppDependencyRepository.repositoriesContainer.get<IntroShowedRepository>()
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    AppDependencyRepository.repositoriesContainer.get<IntroShowedRepository>().dispose();
    AppDependencyRepository.repositoriesContainer.unregister<IntroShowedRepository>();
    homeBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>.value(
      value: homeBloc,
      child: HomeScreen(
        homeBloc: homeBloc,
      ),
    );
  }

}
			