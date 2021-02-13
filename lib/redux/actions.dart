import 'package:equatable/equatable.dart';
import 'package:stackoverflow/api/retrofit.dart';

// load items from API
class LoadTagsAction extends Equatable {
  final int page;
  final int itemsPerPage;
  final bool refresh; // if refresh => clear cache

  LoadTagsAction(this.page, this.itemsPerPage, {this.refresh = false});

  @override
  List<Object> get props => [page, itemsPerPage];
}

class LoadQuestionsAction extends Equatable {
  final int page;
  final int itemsPerPage;
  final bool refresh; // if refresh => clear cache

  LoadQuestionsAction(this.page, this.itemsPerPage, {this.refresh = false});

  @override
  List<Object> get props => [page, itemsPerPage];
}


// handle loaded items
class TagsLoadedAction extends Equatable {
  final List<Tag> list;
  final int pageLoaded;

  TagsLoadedAction(this.list, this.pageLoaded);

  @override
  List<Object> get props => [list, pageLoaded];
}

class QuestionsLoadedAction extends Equatable {
  final List<Question> list;

  QuestionsLoadedAction(this.list);

  @override
  List<Object> get props => [list];
}


// navigation handling, can be easily edited to pass a Navigator path (e.g. /tags/android) instead of a manual switch if needed
class OpenQuestionsAction extends Equatable {
  final String tag;

  OpenQuestionsAction(this.tag);

  @override
  List<Object> get props => [tag];
}

class OpenTagsAction extends Equatable {
  OpenTagsAction();

  @override
  List<Object> get props => [];
}


// handle errors
class ErrorOccuredAction extends Equatable {
  final Exception error;

  ErrorOccuredAction(this.error);

  @override
  List<Object> get props => [error];
}

class ErrorFixedAction extends Equatable {
  final Exception error;

  ErrorFixedAction(this.error);

  @override
  List<Object> get props => [error];
}
