import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:stackoverflow/api/retrofit.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:stackoverflow/redux/actions.dart';

class ApiMiddleware extends MiddlewareClass<AppState>{
  ApiMiddleware();

  Logger logger = Logger();
  Dio dio = Dio();
  RestClient client;

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    client = RestClient(dio); // API client called

    if (action is LoadTagsAction) {
      logger.i('Start API');
      // can't run these at the same time w/o cache as we need
      client.getTags(action.itemsPerPage, action.page).then((list) {
        List<String> tagNames = list.map((tag) => tag.name).toList();

        client.getWikis(Uri.encodeComponent(tagNames.join(';'))).then((wiki) {
          // logger.i(wiki);
          List<Tag> withWiki = list.map((tag) => Tag(tag.name, wiki.firstWhere((element) => element.name == tag.name).description, tag.count)).toList();
          logger.i(withWiki);
          store.dispatch(TagsLoadedAction(withWiki, action.page));
        }).catchError((exception, stacktrace) {
          store.dispatch(TagsLoadedAction(list, action.page)); // show tags without wiki if can't get them
          store.dispatch(ErrorOccuredAction(exception));
        });
      }).catchError((exception, stacktrace) {
        store.dispatch(ErrorOccuredAction(exception));
      });
    }


    next(action);
  }
}