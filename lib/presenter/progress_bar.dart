import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  CustomProgressIndicator({this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    // to update progress bar style everyone in the app
    return isActive ? Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(child: CircularProgressIndicator(strokeWidth: 3))) : Container();
  }
}