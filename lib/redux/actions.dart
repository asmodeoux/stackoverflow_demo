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
  final int pageLoaded;

  QuestionsLoadedAction(this.list, this.pageLoaded);

  @override
  List<Object> get props => [list, pageLoaded];
}


// navigation handling
class NavigateAction extends Equatable {
  NavigateAction(this.tag);

  final String tag; // pass tag name if opening questions, and null if poping it

  @override
  List<Object> get props => [tag];
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
