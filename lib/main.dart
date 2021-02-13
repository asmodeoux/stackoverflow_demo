import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:stackoverflow/presenter/viewmodel.dart';
import 'package:stackoverflow/redux/middleware_api.dart';
import 'package:stackoverflow/redux/middleware_logging.dart';
import 'package:stackoverflow/redux/reducers.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // invokes the initial store state
  final store = Store<AppState>(
    appStateReducers,
    initialState: AppState.initial(),
    middleware: [
      ApiMiddleware(),
      LoggingMiddleware(),
      // CachingMiddleware() // can be enabled and used via Redux if it's needed
    ]
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StackOverflow Demo',
        home: TagsContainer(),
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
      ),
    );
  }
}
