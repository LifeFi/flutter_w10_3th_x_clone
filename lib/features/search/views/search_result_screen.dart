import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/search/view_models/search_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/thread.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  static const String routeName = "searchResult";
  static const String routeURL = "/search/:keyword";

  final String keyword;
  const SearchResultScreen({
    super.key,
    required this.keyword,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isMoreLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);

    Future.microtask(() {
      _refresh();
    });
  }

  Future<void> _loadMore() async {
    if (_isLoading || _isMoreLoading) return;
    // print("pixels: ${_scrollController.position.pixels}");
    // print("max: ${_scrollController.position.maxScrollExtent}");
    // print("viewport: ${_scrollController.position.viewportDimension}");
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) await _fetchNextItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    // state 를 ref.warch 하고 있으므로 여기는 setState 안함.
    _isLoading = true;
    await ref
        .read(searchProvider.notifier)
        .searchThreads(context, widget.keyword);
    _isLoading = false;
  }

  Future<void> _fetchNextItems() async {
    // 하단에는 로딩바 위해 setState 필요.
    setState(() {
      _isMoreLoading = true;
    });
    // await Future.delayed(const Duration(seconds: 2));
    await ref.read(searchProvider.notifier).searchNextThreads(widget.keyword);
    if (!mounted) return;
    setState(() {
      _isMoreLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(searchProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.keyword),
        ),
        body: ref.watch(searchProvider).when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(100),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Text(
                  'Could not load threads: $error',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              data: (threads) {
                // print(threads.length);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size10,
                  ),
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: threads.length + 1,
                      itemBuilder: (context, index) {
                        if (index < threads.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size12,
                            ),
                            child: Thread(
                              id: threads[index].id,
                              creator: threads[index].creator,
                              creatorUid: threads[index].creatorUid,
                              content: threads[index].content,
                              images: threads[index].images,
                              commentOf: threads[index].commentOf,
                              comments: threads[index].comments,
                              likes: threads[index].likes,
                              replies: threads[index].replies,
                              createdAt: threads[index].createdAt!.toDate(),
                            ),
                          );
                        } else if (_isMoreLoading) {
                          return Container(
                            padding: const EdgeInsets.only(
                              top: Sizes.size10,
                              bottom: Sizes.size28,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.only(
                            top: Sizes.size10,
                            bottom: Sizes.size28,
                          ),
                        );
                      }),
                );
              },
            ));
  }
}
