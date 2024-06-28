import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/enum.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/follow_data_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/follow_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/avatar.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/widgets/follow_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FollowList extends ConsumerStatefulWidget {
  final String? uid;
  final FollowType fetchType;

  const FollowList({
    super.key,
    required this.fetchType,
    this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollowListState();
}

class _FollowListState extends ConsumerState<FollowList>
    with AutomaticKeepAliveClientMixin {
  // final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isMoreLoading = false;
  List<FollowDataModel> _list = [];
  late Timestamp? _lastUserFollowedAt;

  // Followering, followers 탭 이동시에도 dispose 되지 않도록
  // with AutomaticKeepAliveClientMixin 하고
  // bool get wantKeepAlive => true; 을 override 하고
  // build 함수에, super.build(context); 를 추가하였음.
  // 상위, 위젯이 dispose 되면 그때 dispose 됨. ( 내가 원하는 대로임. )
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_loadMore);

    Future.microtask(() async {
      setState(() {
        _isLoading = true;
      });
      await _refresh();
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    print("disposed!");
    super.dispose();
  }

  void _showUserProfile(String uid) {}

  Future<void> _refresh() async {
    print("widget.uid: ${widget.uid}");

    // await Future.delayed(const Duration(seconds: 1));

    _list = await ref.read(followProvider.notifier).fetchFollow(
          fetchType: widget.fetchType,
          uid: widget.uid,
        );

    _lastUserFollowedAt = _list.isEmpty ? null : _list.last.followedAt;
    print(
        "_list.last.followedAt ${_list.isEmpty ? null : _list.last.followedAt}");

    setState(() {
      _isLoading = false;
    });
  }

/* 
  bool _loadMore(ScrollNotification notification) {
    print("pixels: ${notification.metrics.pixels}");
    print("max: ${notification.metrics.maxScrollExtent}");
    print("viewport: ${notification.metrics.viewportDimension}");
    // print(
    // "dif: ${notification.metrics.maxScrollExtent - notification.metrics.pixels}")

    if (notification.metrics.pixels > 10 &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent &&
        !_isLoading) {
      // print("Load more!============================");
      _fetchNextItems();
    }
    return true;
  }
 */
/* 
  bool _loadMore() {
    print("pixels: ${_scrollController.position.pixels}");
    print("max: ${_scrollController.position.maxScrollExtent}");
    print("viewport: ${_scrollController.position.viewportDimension}");
    print(
        "dif: ${_scrollController.position.pixels - _scrollController.position.maxScrollExtent}");
    if (_scrollController.position.pixels > 10 &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      print("Load more!============================");
      _fetchNextItems();
    }
    return true;
  }
 */
  _loadMore() {
    print("Load more!============================");

    fetchNextItems();
  }

  Future<void> fetchNextItems() async {
    if (_isLoading || _isMoreLoading) return;
    // 리스트 하단에 로딩바를 보여주기 위함.
    setState(() {
      _isMoreLoading = true;
    });
    // await Future.delayed(const Duration(seconds: 2));
    print("_lastUserFollowedAt:$_lastUserFollowedAt");
    final result = await ref.read(followProvider.notifier).fetchFollow(
          fetchType: widget.fetchType,
          uid: widget.uid,
          lastUserFollowedAt: _lastUserFollowedAt,
        );

    _list = [..._list, ...result];
    _lastUserFollowedAt = _list.isEmpty ? null : _list.last.followedAt;

    setState(() {
      _isMoreLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final followNum = widget.fetchType == FollowType.following
        ? ref.read(usersProvider(widget.uid)).value!.following
        : ref.read(usersProvider(widget.uid)).value!.following;

    return RefreshIndicator.adaptive(
      displacement: Sizes.size80,
      onRefresh: _refresh,
      child: ListView.builder(
        primary: true,
        itemCount: _list.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.size5,
                ),
                child: CupertinoSearchTextField());
          }
          if (!_isLoading) {
            if (index < _list.length + 1) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size5,
                  vertical: Sizes.size5,
                ),
                title: Row(
                  children: [
                    Avatar(
                        userId: _list[index - 1].uid,
                        userName: _list[index - 1].name,
                        hasFollowBtn: false),
                    Gaps.h10,
                    Expanded(
                      child: Text(_list[index - 1].name),
                    ),
                    FollowButton(
                      uid: _list[index - 1].uid,
                      name: _list[index - 1].name,
                    ),
                  ],
                ),
              );
            } else if (!_isMoreLoading) {
              if (_list.length >= 5 && _list.length < followNum) {
                // print(_list.length);
                // print(followNum);

                // Scroll event 로 maxScrollExtent 값이 계속 0으로 잡혀
                // 다른 방식(VisibilityDector 패키지 설치)으로 infinity 스크롤 구현함.
                return VisibilityDetector(
                  key: const Key("onLoadMore"),
                  onVisibilityChanged: (info) {
                    if (info.visibleFraction == 1) {
                      _loadMore();
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 5,
                    decoration: const BoxDecoration(
                        // color: Colors.red,
                        ),
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: const BoxDecoration(
                      // color: Colors.yellow,
                      ),
                );
              }
            } else {
              // 하단에 isMoreLoading 중이면
              return Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 10,
                    ),
                    child: const CircularProgressIndicator.adaptive()),
              );
            }
            // user_repo 의 _followUsersFetchLimit 와 동일한 숫자(10)를 수작업으로 넣어줌.
          } else {
            // 상단에 iseLoading 중이면, 첫번째 타일에만 프로그레스바
            if (index == 1) {
              return const Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Sizes.size40,
                    ),
                    child: CircularProgressIndicator.adaptive()),
              );
            }
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          );
        },
      ),
    );
  }
}
