import 'package:equatable/equatable.dart';
import 'package:stackoverflow/api/retrofit.dart';

// Models of Tag and Question are in api/retrofit.dart file

class AppState extends Equatable {
  final bool areTagsLoading;
  final bool areQuestionsLoading;
  // navigation state
  final int tagsPage;
  final int questionsPage;
  final String tagSelected;
  // view state
  final List<Tag> tagsLoaded;
  final List<Question> questionsLoaded;
  // to handle exceptions
  final Exception error;

  // initial state may include the pre-cached data from SharedPrefs
  factory AppState.initial() => AppState(
      areTagsLoading: true,
      areQuestionsLoading: false,
      tagsPage: 1,
      questionsPage: 1,
      tagSelected: null,
      tagsLoaded: const [],
      questionsLoaded: const [],
      error: null);

  AppState({this.areTagsLoading,
    this.areQuestionsLoading,
    this.tagsPage,
    this.questionsPage,
    this.tagSelected,
    this.tagsLoaded,
    this.questionsLoaded,
    this.error});

  AppState copyWith({
    areTagsLoading,
    areQuestionsLoading,
    tagsPage,
    questionsPage,
    tagSelected,
    tagsLoaded,
    questionsLoaded,
    error
  }) {
    return AppState(
        areTagsLoading: areTagsLoading ?? this.areTagsLoading,
        areQuestionsLoading: areQuestionsLoading ?? this.areQuestionsLoading,
        tagsPage: tagsPage ?? this.tagsPage,
        questionsPage: questionsPage ?? this.questionsPage,
        tagSelected: tagSelected ?? this.tagSelected,
        tagsLoaded: tagsLoaded ?? this.tagsLoaded,
        questionsLoaded: questionsLoaded ?? this.questionsLoaded,
        error: error ?? this.error
    );
  }

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'AppState{areTagsLoading: $areTagsLoading, areQuestionsLoading: $areQuestionsLoading, tagsPage: $tagsPage, questionsPage: $questionsPage, tagSelected: $tagSelected, tagsLoaded: $tagsLoaded, questionsLoaded: $questionsLoaded, error: $error}';
  }
}

class Constants {
  static const int TAGS_PER_PAGE = 20; // 20 is the API limit
  static const int QUESTIONS_PER_PAGE = 20;
  static const int DEBOUNCER_TIMER = 500;
  static const double SCROLL_THRESHOLD_PIXELS = 100.0;
}