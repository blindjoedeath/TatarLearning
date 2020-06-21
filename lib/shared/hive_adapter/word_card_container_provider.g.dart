// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:app/shared/entity/word_card.dart';
import 'word_card_container.dart';
import 'package:hive/hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordCardContainerAdapter extends TypeAdapter<WordCardContainer> {
  @override
  WordCardContainer read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    var container = WordCardContainer()
        ..cards = (fields[0] as List)?.cast<WordCard>();
    return container;
  }

  @override
  void write(BinaryWriter writer, WordCardContainer obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.cards);
  }

  @override
  int get typeId => 2;
}
