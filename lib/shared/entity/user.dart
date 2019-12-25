import 'package:flutter/material.dart';

class User{
  final String avatarUrl;
  final String name;
  final String surname;
  final String token;

  const User({@required this.avatarUrl, @required this.name, @required this.surname,@required this.token});
  
}