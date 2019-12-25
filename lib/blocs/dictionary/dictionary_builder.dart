import 'package:app/shared/repository/app_dependency_repository.dart';
import 'package:app/shared/repository/dictionary_repository.dart';
import 'package:app/shared/repository/user_repository.dart';
import 'package:dioc/dioc.dart';

import 'dictionary_screen.dart';
import 'dictionary_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionaryBuilder extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _DictionaryBuilderState();

}

class _DictionaryBuilderState extends State<DictionaryBuilder>{

  DictionaryBloc dictionaryBloc;

  @override
  void initState() {
    AppDependencyRepository
      .repositoriesContainer
      .register<DictionaryRepository>((c) => DictionaryRepository(), defaultMode: InjectMode.singleton);

    dictionaryBloc = DictionaryBloc(
      dictionaryRepository: AppDependencyRepository.repositoriesContainer.get<DictionaryRepository>(),
      userRepository: AppDependencyRepository.repositoriesContainer.get<UserRepository>(),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    AppDependencyRepository
      .repositoriesContainer
      .unregister<DictionaryRepository>();
    dictionaryBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DictionaryBloc>.value(
      value: dictionaryBloc,
      child: DictionaryScreen(
        dictionaryBloc: dictionaryBloc,
      ),
    );
  }

}
			