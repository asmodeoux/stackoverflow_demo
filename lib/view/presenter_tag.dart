import 'package:flutter/cupertino.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackoverflow/api/retrofit.dart';
import 'package:flutter/material.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:stackoverflow/tools/debouncer.dart';
import 'package:stackoverflow/view/error_notifier.dart';
import 'package:stackoverflow/view/progress_bar.dart';
import 'package:redux/redux.dart';
import 'package:stackoverflow/redux/actions.dart';

class TagsScreen extends StatefulWidget {
  TagsScreen({
    this.isDataLoading,
    this.items,
    this.refresh,
    this.loadNextPage,
    this.noError,
    this.store
  });

  final bool isDataLoading;
  final List<Tag> items;
  final Function refresh;
  final Function loadNextPage;
  final bool noError;
  final Store<AppState> store;

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
                  ? TagPresenter(tag: widget.items[index], store: widget.store)
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
    @required this.store
  }) : super(key: key);

  final Tag tag;
  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        title: Row(
            children: [
              Container(
                child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          child: Center(child: tag.name == 'android' ? Padding(padding: const EdgeInsets.all(2.0), child: SvgPicture.asset('lib/assets/android_icon.svg'))
                              : Text('#', style: TextStyle(color: Colors.white))),
                          decoration: BoxDecoration(
                            color: Color(0x80D8D8D8),
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          height:20,
                          width: 20
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(tag.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center
                ),
                decoration: BoxDecoration(
                  color: tag.name == 'android' ? Color(0xFF00D46B) : Color(0xFF9FABBA), // changing tag color for android
                  borderRadius: BorderRadius.circular(15.0)
                ),
                height: 30
              ),
              Text(tag.formattedCount, style: TextStyle(fontWeight: FontWeight.w400, color: Color(0x80000000)))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6, left: 5, right: 5),
          child: Text(tag.formattedDescription)
        ),
        onTap: () {
          // open questions page for a certain tag
          store.dispatch(NavigateToAction.push(
            '/questions',
            preNavigation: () => store.dispatch(NavigateAction(tag.name)) // set selected tag
          )); // triggering Navigator
        }
      )
    );
  }
}