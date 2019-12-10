import 'dart:async';
import 'package:app/shared/entity/search_queries.dart';
import 'package:hive/hive.dart';


const String kQueriesKey = 'queries';

class SearchHistoryRepository{

  bool get isInited => Hive.isBoxOpen(kQueriesKey);

  Future init()async{
    await Hive.openBox(kQueriesKey);
  }

  SearchQueries get(){
    return Hive.box(kQueriesKey).get(kQueriesKey, defaultValue: SearchQueries());
  }

  Future<void> save(SearchQueries query)async{
    return Hive.box(kQueriesKey).put(kQueriesKey, query);
  }

  void dispose(){
    if (isInited){
      Hive.box(kQueriesKey).close();
    }
  }

}