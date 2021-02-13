import 'package:flutter/cupertino.dart';
import 'package:stackoverflow/api/retrofit.dart';
import 'package:flutter/material.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:stackoverflow/presenter/debouncer.dart';
import 'package:stackoverflow/presenter/error_notifier.dart';
import 'package:stackoverflow/presenter/progress_bar.dart';

class QuestionsScreen extends StatefulWidget {
  QuestionsScreen({
    this.tagName,
    this.isDataLoading,
    this.items,
    this.refresh,
    this.loadNextPage,
    this.noError,
  });

  final String tagName;
  final bool isDataLoading;
  final List<Question> items;
  final Function refresh;
  final Function loadNextPage;
  final bool noError;

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  ScrollController _scrollController = ScrollController();
  final _scrollThresholdInPixels = Constants.SCROLL_THRESHOLD_PIXELS;
  final _debouncer = Debouncer(milliseconds: Constants.DEBOUNCER_TIMER);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tagName ?? 'Questions'),
      ),
      body: ErrorNotifier(
        child: widget.isDataLoading && widget.items.length == 0
            ? CustomProgressIndicator(isActive: widget.isDataLoading)
            : RefreshIndicator(
          child: ListView.separated(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: widget.items.length + 1,
            itemBuilder: (context, index) {
              return (index < widget.items.length)
                  ? QuestionPresenter(question: widget.items[index])
                  : CustomProgressIndicator(isActive: widget.noError);
            },
            controller: _scrollController,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: Theme.of(context).dividerColor),
          ),
          onRefresh: _onRefresh,
        ),
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThresholdInPixels &&
        !widget.isDataLoading) {
      _debouncer.run(() => widget.loadNextPage());
    }
  }

  Future _onRefresh() {
    widget.refresh();
    return Future.value();
  }
}

class QuestionPresenter extends StatelessWidget {
  const QuestionPresenter({
    Key key,
    @required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
        title: Text(
          '${question.title}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(question.body),
            Text(question.dateFormatted),
          ],
        ),
        isThreeLine: true,
      ),
      height: 60.0,
    );
  }
}