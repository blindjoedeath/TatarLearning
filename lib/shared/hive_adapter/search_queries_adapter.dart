// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:app/shared/entity/search_queries.dart';
import 'package:hive/hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchQueriesAdapter extends TypeAdapter<SearchQueries> {
  @override
  SearchQueries read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchQueries()..value = (fields[0] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, SearchQueries obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get typeId => 0;
}
