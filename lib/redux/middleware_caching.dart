import 'package:redux/redux.dart';
import 'package:stackoverflow/model/model.dart';

class CachingMiddleware extends MiddlewareClass<AppState>{
  CachingMiddleware();

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    // for an ability to quickly implement caching via SharedPreferences if its needed
    next(action);
  }
}