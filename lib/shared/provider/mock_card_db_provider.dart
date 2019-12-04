import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../entity/card.dart';

class MockCardDbProvider {

  Future<List<Card>> fetchCards(String text) {
    return Future<List<Card>>.value(
      List<Card>.generate(10, (index){
        return Card(
          word: "$text $index",
          description: "Description $index",
          translates: ["Translate 1", "Translate 2"],
          imageUrl: "http://sun9-14.userapi.com/c849424/v849424786/15eee3/Y4C7mfELwBA.jpg?ava=1"
        );
      })
    );
  }
}