import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:redux/redux.dart';
import 'package:stackoverflow/redux/actions.dart';

class ErrorNotifier extends StatelessWidget {
  ErrorNotifier({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, vm) => child,
      onDidChange: (vm) {
        if (vm.error != null) {
          vm.markErrorAsHandled();
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(vm.error.toString() ?? 'Unknown exception')));
          // shows a Snackbar with error info
          // this Snackbar might include action button or action to hide
        }
      },
      distinct: true,
    );
  }
}

class _ViewModel {
  _ViewModel({
    this.markErrorAsHandled,
    this.error,
  });

  final Function markErrorAsHandled;
  final Exception error;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      markErrorAsHandled: () => store.dispatch(ErrorFixedAction(store.state.error)),
      error: store.state.error,
    );
  }

  @override
  int get hashCode => error.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
          other is _ViewModel && other.error == this.error;
}