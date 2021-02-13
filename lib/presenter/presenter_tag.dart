import 'package:flutter/cupertino.dart';
import 'package:stackoverflow/api/retrofit.dart';
import 'package:flutter/material.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:stackoverflow/presenter/debouncer.dart';
import 'package:stackoverflow/presenter/error_notifier.dart';
import 'package:stackoverflow/presenter/progress_bar.dart';

class TagsScreen extends StatefulWidget {
  TagsScreen({
    this.isDataLoading,
    this.items,
    this.refresh,
    this.loadNextPage,
    this.noError,
  });

  final bool isDataLoading;
  final List<Tag> items;
  final Function refresh;
  final Function loadNextPage;
  final bool noError;

  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
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
        title: Text('Tags'),
      ),
      body: ErrorNotifier(
        child: widget.isDataLoading && widget.items.length == 0
            ? CustomProgressIndicator(isActive: widget.isDataLoading)
            : RefreshIndicator(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 6),
            physics: BouncingScrollPhysics(),
            itemCount: widget.items.length + 1,
            itemBuilder: (context, index) {
              return (index < widget.items.length)
                  ? TagPresenter(tag: widget.items[index])
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
    if (maxScroll - currentScroll <= _scrollThresholdInPixels && !widget.isDataLoading) {
      _debouncer.run(() => widget.loadNextPage());
    }
  }

  Future _onRefresh() {
    widget.refresh();
    return Future.value();
  }
}

class TagPresenter extends StatelessWidget {
  const TagPresenter({
    Key key,
    @required this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        title: Row(
          children: [
            Text(tag.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis
            ),
            Text('${tag.count}')
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween
        ),
        subtitle: Column(
          children: [
            Text(tag.formattedDescription),
          ],
          crossAxisAlignment: CrossAxisAlignment.start
        ),
      )
    );
  }
}