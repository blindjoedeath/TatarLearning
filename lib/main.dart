import 'package:app/blocs/app/app_builder.dart';
import 'package:app/shared/entity/search_queries.dart';
import 'package:app/shared/entity/word_card.dart';
import 'package:app/shared/hive_adapter/search_queries_adapter.dart';
import 'package:app/shared/hive_adapter/word_card_adapter.dart';
import 'package:app/shared/hive_adapter/word_card_container_provider.g.dart';
import 'package:app/shared/repository/search_history_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(SearchQueriesAdapter());
  Hive.registerAdapter(WordCardAdapter());
  Hive.registerAdapter(WordCardContainerAdapter());

 
  runApp(AppBuilder(
  ));
}