import 'package:hive/hive.dart';

@HiveType()
class WordCard{
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final String word;

  @HiveField(3)
  final List<String> translates;

  @HiveField(4)
  final String description;

  const WordCard({this.id, this.imageUrl, this.word, this.translates, this.description});
}