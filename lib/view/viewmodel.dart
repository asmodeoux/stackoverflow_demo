import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:stackoverflow/api/retrofit.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:redux/redux.dart';
import 'package:stackoverflow/view/presenter_question.dart';
import 'package:stackoverflow/view/presenter_tag.dart';
import 'package:stackoverflow/redux/actions.dart';

class _ViewModel {
  _ViewModel({
    this.store,
    this.areTagsLoading,
    this.areQuestionsLoading,
    this.tagSelected,
    this.tagsLoaded,
    this.questionsLoaded,
    this.error
  });

  final Store<AppState> store;
  final bool areTagsLoading;
  final bool areQuestionsLoading;
  // navigation state
  final String tagSelected;
  // view state
  final List<Tag> tagsLoaded;
  final List<Question> questionsLoaded;
  // to handle exceptions
  final Exception error;

  void onLoadNextTagsPage() {
    if (!areTagsLoading) {
      store.dispatch(LoadTagsAction((tagsLoaded.length ~/ Constants.TAGS_PER_PAGE) + 1, Constants.TAGS_PER_PAGE));
    }
  }

  void onLoadNextQuestionsPage() {
    if (!areQuestionsLoading) {
      store.dispatch(LoadQuestionsAction(
        (questionsLoaded.length ~/ Constants.QUESTIONS_PER_PAGE) + 1,
        Constants.QUESTIONS_PER_PAGE
      ));
    }
  }

  void onRefreshTags() {
    store.dispatch(LoadTagsAction(1, Constants.TAGS_PER_PAGE, refresh: true));
  }

  void onRefreshQuestions() {
    store.dispatch(LoadQuestionsAction(1, Constants.QUESTIONS_PER_PAGE, refresh: true));
  }

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        areTagsLoading: store.state.areTagsLoading,
        areQuestionsLoading: store.state.areQuestionsLoading,
        tagsLoaded: store.state.tagsLoaded,
        questionsLoaded: store.state.questionsLoaded,
        store: store,
        error: store.state.error
    );
  }
}

class TagsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      builder: (context, vm) {
        return TagsScreen(
            isDataLoading: vm.areTagsLoading,
            items: vm.tagsLoaded,
            refresh: vm.onRefreshTags,
            loadNextPage: vm.onLoadNextTagsPage,
            noError: vm.error == null,
            store: vm.store
        );
      },
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(LoadTagsAction(1, Constants.TAGS_PER_PAGE));
      }
    );
  }
}

class QuestionsContainer extends StatelessWidget {
  final String tagName; // to force specific tag name if couldn't get from the store
  QuestionsContainer({this.tagName});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        builder: (context, vm) {
          return QuestionsScreen(
              tagName: vm.tagSelected ?? tagName,
              isDataLoading: vm.areQuestionsLoading,
              items: vm.questionsLoaded,
              refresh: vm.onRefreshQuestions,
              loadNextPage: vm.onLoadNextQuestionsPage,
              noError: vm.error == null,
              store: vm.store
          );
        },
        converter: _ViewModel.fromStore,
        onInit: (store) {
          store.dispatch(LoadQuestionsAction(1, Constants.TAGS_PER_PAGE));
        },
        onDispose: (store) {
          store.dispatch(NavigateAction(null));
        }
    );
  }
}
