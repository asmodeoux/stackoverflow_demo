import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:stackoverflow/api/retrofit.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:stackoverflow/redux/actions.dart';

Logger logger = Logger();
Dio dio = Dio();
RestClient client;

AppState appStateReducers(AppState state, dynamic action) {
  client = RestClient(dio);

  if (action is LoadTagsAction) {
    return loadTags(state, action);
  } else if (action is LoadQuestionsAction) {
    return loadQuestions(state, action);
  } else if (action is TagsLoadedAction) {
    return showTags(state, action);
  } else if (action is QuestionsLoadedAction) {
    return showQuestions(state, action);
  } else if (action is OpenQuestionsAction) {
    return openQuestions(state, action);
  } else if (action is OpenTagsAction) {
    return openTags(state, action);
  } else if (action is ErrorOccuredAction) {
    return handleError(state, action);
  } else if (action is ErrorFixedAction) {
    return hideError(state, action);
  } else {
    logger.e('Unhandled action: $action');
  }

  return state;
}

AppState loadTags(AppState state, LoadTagsAction action) {
  if (action.refresh) return state.copyWith(tagsLoaded: <Tag>[]); // reset list if refreshing
  return state;
}

AppState loadQuestions(AppState state, LoadQuestionsAction action) {
  if (action.refresh) return state.copyWith(questionsLoaded: <Question>[]); // reset list if refreshing
  return state;
}

AppState showTags(AppState state, TagsLoadedAction action) {
  // add new tags to the list
  List<Tag> tags = [];
  tags.addAll(state.tagsLoaded);

  List<Tag> filtered = []; // filters the list to make sure there are no repeats

  // TODO action.list.map((tag) {if (!state.tagsLoaded.any((element) => element.name == tag.name)) filtered.add(tag);});
  filtered.addAll(action.list);
  tags.addAll(filtered);
  return state.copyWith(tagsLoaded: tags, areTagsLoading: false, tagsPage: action.pageLoaded);
}

AppState showQuestions(AppState state, QuestionsLoadedAction action) {
  // TODO finish reducer
  return state;
}

AppState openQuestions(AppState state, OpenQuestionsAction action) {
  // TODO finish reducer
  return state;
}

AppState openTags(AppState state, OpenTagsAction action) {
  // TODO finish reducer
  return state;
}

AppState handleError(AppState state, ErrorOccuredAction action) {
  // TODO finish reducer
  return state.copyWith(error: action.error);
}

AppState hideError(AppState state, ErrorFixedAction action) {
  // TODO finish reducer
  return state.copyWith(error: null);
}