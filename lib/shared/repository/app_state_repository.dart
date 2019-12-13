import 'package:flutter/material.dart';

abstract class AppStateRepository {
  Stream<AppLifecycleState> get appStateStream;
  AppLifecycleState get appState;
}