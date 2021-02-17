import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:stackoverflow/redux/middleware_api.dart';
import 'package:stackoverflow/redux/middleware_logging.dart';
import 'package:stackoverflow/redux/reducers.dart';

Future<Store<AppState>> createReduxStore() async {
  return DevToolsStore<AppState>(
    appStateReducers,
    initialState: AppState.initial(),
    middleware: [
      NavigationMiddleware<AppState>(),
      ApiMiddleware(),
      LoggingMiddleware(),
      // CachingMiddleware() // can be enabled and used via Redux if it's needed
    ]
  );
}