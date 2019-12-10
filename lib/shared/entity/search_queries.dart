import 'package:hive/hive.dart';

const int _kCapacity = 3;

@HiveType()
class SearchQueries{
  @HiveField(0)
  List<String> value = List<String>();

  void add(String query){
    if (!value.contains(query) && value.length == _kCapacity){
      value.removeAt(0);
    } else if (value.contains(query) && value.last != query){
      value.remove(query);
    } else {
      return;
    }
    value.add(query);
  }

}