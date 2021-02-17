import 'package:dio/dio.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
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
  } else if (action is NavigateAction) {
    return navigate(state, action);
  } else if (action is ErrorOccuredAction) {
    return handleError(state, action);
  } else if (action is ErrorFixedAction) {
    return hideError(state, action);
  } else if (action is! NavigateToAction){
    logger.e('Unhandled action: $action');
  }

  return state;
}

AppState loadTags(AppState state, LoadTagsAction action) {
  if (action.refresh) return state.copyWith(tagsLoaded: <Tag>[]); // reset list if refreshing
  return state.copyWith(areTagsLoading: true);
}

AppState loadQuestions(AppState state, LoadQuestionsAction action) {
  if (action.refresh) return state.copyWith(questionsLoaded: <Question>[]); // reset list if refreshing
  return state.copyWith(areQuestionsLoading: true);
}

AppState showTags(AppState state, TagsLoadedAction action) {
  // add new tags to the list
  List<Tag> tags = [];
  tags.addAll(state.tagsLoaded);

  List<Tag> filtered = []; // filters the list to make sure there are no repeats

  try {
    for (Tag t in action.list) {
      if (!tags.any((element) => element.name == t.name) && !filtered.any((element) => element.name == t.name)) filtered.add(t);
    }
  } catch (e) {
    logger.e(e);
  }

  tags.addAll(filtered);
  return state.copyWith(tagsLoaded: tags, areTagsLoading: false, tagsPage: action.pageLoaded);
}

AppState showQuestions(AppState state, QuestionsLoadedAction action) {
  // add new questions to the list
  List<Question> questions = [];
  if (action.pageLoaded != 1) questions.addAll(state.questionsLoaded); // to prevent adding questions from another tag

  List<Question> filtered = []; // filters the list to make sure there are no repeats

  try {
    for (Question q in action.list) {
      if (!questions.any((element) => element.id == q.id)) filtered.add(q);
    }
  } catch (e) {
    logger.e(e);
  }

  questions.addAll(filtered);
  logger.d('filtered questions found: ${filtered.length}');
  logger.d('questions total: ${questions.length}');

  return state.copyWith(questionsLoaded: questions, areQuestionsLoading: false, questionsPage: action.pageLoaded);
}

AppState navigate(AppState state, NavigateAction action) {
  // changing state's selected tag
  return state.copyWith(tagSelected: action.tag, questionsLoaded: action.tag == null ? <Question>[] : state.questionsLoaded);
}

AppState handleError(AppState state, ErrorOccuredAction action) {
  // you can handle complex errors here, currently showing it in a Snackbar
  return state.copyWith(error: action.error, areTagsLoading: false, areQuestionsLoading: false);
}

AppState hideError(AppState state, ErrorFixedAction action) {
  return state.copyWith(error: null, areTagsLoading: false, areQuestionsLoading: false);
}