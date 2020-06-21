// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:app/shared/entity/word_card.dart';
import 'package:hive/hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordCardAdapter extends TypeAdapter<WordCard> {
  @override
  WordCard read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordCard(
      id: fields[0] as String,
      imageUrl: fields[1] as String,
      word: fields[2] as String,
      translates: (fields[3] as List)?.cast<String>(),
      description: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordCard obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.word)
      ..writeByte(3)
      ..write(obj.translates)
      ..writeByte(4)
      ..write(obj.description);
  }

  @override
  int get typeId => 1;
}
