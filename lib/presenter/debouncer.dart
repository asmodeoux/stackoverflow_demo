import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({this.milliseconds});

  // used for a scroll controller to limit update frequency

  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  run(VoidCallback action) {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}