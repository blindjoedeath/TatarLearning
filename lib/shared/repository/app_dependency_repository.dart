import 'package:dioc/dioc.dart';


class AppDependencyRepository{

  static Container _blocs;
  static Container _repositories;
  static Container _providers;

  static Container get blocsContainer {
    if (_blocs == null){
      _blocs = Container();
    }
    return _blocs;
  }

  static Container get repositoriesContainer {
    if (_repositories == null){
      _repositories = Container();
    }
    return _repositories;
  }

  static Container get providersContainer {
    if (_providers == null){
      _providers = Container();
    }
    return _providers;
  }

}