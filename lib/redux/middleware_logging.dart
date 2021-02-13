import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:stackoverflow/redux/actions.dart';

class LoggingMiddleware extends MiddlewareClass<AppState>{
  LoggingMiddleware();

  Logger logger = Logger();

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is! DevToolsAction && action is! ErrorOccuredAction) {
      logger.i('Action triggered: $action');
    }

    if (action is ErrorOccuredAction) {
      logger.e(action.error);
    }

    // was used to debug tags
    // if (action is TagsLoadedAction) {
    //   logger.i(store.state.tagsLoaded.length + action.list.length);
    // }

    // may contain more action-specific data for debugging
    next(action);
  }
}