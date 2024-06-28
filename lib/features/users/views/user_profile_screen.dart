import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/threads_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/thread.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/show_bottom_tap_bar.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/views/settings_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/follow_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/widgets/follow_button.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/widgets/profile_avatar.dart';
import 'package:flutter_w10_3th_x_clone/features/users/widgets/persistant_tab_bar.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = "profile";
  static const String routeURL = "/profile/:uid";
  final String? uid;

  const UserProfileScreen({
    super.key,
    this.uid,
  });

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;

  _toggleShowBottomTabBar() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        ref.read(showBottomTabBarProvider.notifier).state) {
      ref.read(showBottomTabBarProvider.notifier).state = false;
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        !ref.read(showBottomTabBarProvider.notifier).state) {
      ref.read(showBottomTabBarProvider.notifier).state = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_toggleShowBottomTabBar);
  }

  bool _loadMore(ScrollNotification notification) {
    // 아이템 개수가 0이거나 5개 언더로 소수일떄, _fetchNextItems 안되도록 막기 위함.
    // 화면을 보면서 적당히 100 으로 잡았음.
    if (notification.metrics.pixels > 100 &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent &&
        !_isLoading) {
      // bool 값을 바로 줘야 하기 때문에, 로딩을 처리하기 위해서 별도 함수를 분리하고,
      // _fetchNezxtItems() 에서 async-await 로 로딩 표시
      _fetchNextItems();
    }
    return true;
  }

  Future<void> _fetchNextItems() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final user = ref.read(authRepo).user;
    await ref
        .read(threadsProvider(widget.uid ?? user!.uid).notifier)
        .fetchNextItems();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSettingsTap() {
    /*    context.goNamed(
      SettingsScreen.routeName,
      pathParameters: {"tab": "profile"},
    ); */
    context.pushNamed(SettingsScreen.routeName);
  }

  Future<void> _onRefresh(String? uid) async {
    // print("uid: $uid");
    await ref.refresh(threadsProvider(uid).future);
    await ref.refresh(usersProvider(uid).future);
    // print("null: following ${ref.read(usersProvider(null)).value!.following}");
    // print(ref.read(usersProvider(uid)).value!.following);
    // print("uid: $uid");
  }

  void _showFollowersModal() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      // showDragHandle: true,
      elevation: 0,
      context: context,
      builder: (context) => FollowScreen(
        uid: widget.uid,
      ),
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.size16),
          topRight: Radius.circular(Sizes.size16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    final user = ref.watch(authRepo).user;
    final isMine = widget.uid == null || widget.uid == user!.uid;
    final threads = ref.watch(threadsProvider(widget.uid ?? user!.uid));
    // print("ref.watch(authRepo).user!.uid : ${ref.watch(authRepo).user!.uid}");
    // print("widget.uid : ${widget.uid}");
    return ref.watch(usersProvider(widget.uid)).when(
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) {
            return Container(
              color: isDark ? Colors.black : Colors.white,
              child: SafeArea(
                child: Scaffold(
                  body: DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            actions: [
                              if (isMine && Navigator.canPop(context)) Gaps.h24,
                              isMine
                                  ? Row(
                                      children: [
                                        Gaps.h10,
                                        IconButton(
                                          onPressed: () {},
                                          icon: const FaIcon(
                                              FontAwesomeIcons.globe),
                                          iconSize: Sizes.size28,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.camera),
                                iconSize: Sizes.size28,
                              ),
                              isMine
                                  ? IconButton(
                                      onPressed: _onSettingsTap,
                                      icon: const FaIcon(
                                          FontAwesomeIcons.barsStaggered),
                                      iconSize: Sizes.size28,
                                    )
                                  : Container(),
                              Gaps.h10,
                            ],
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size20,
                                vertical: Sizes.size10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.name,
                                            style: const TextStyle(
                                              fontSize: Sizes.size24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            data.link,
                                            style: const TextStyle(
                                              fontSize: Sizes.size16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      ProfileAvatar(
                                        name: data.name,
                                        uid: data.uid,
                                        hasAvatar: data.hasAvatar,
                                        canUpload: isMine,
                                      ),
                                    ],
                                  ),
                                  Gaps.v5,
                                  Text(
                                    data.bio,
                                    style: const TextStyle(
                                      fontSize: Sizes.size16,
                                    ),
                                  ),
                                  Gaps.v10,
                                  GestureDetector(
                                    onTap: _showFollowersModal,
                                    child: Text(
                                      "${data.followers} Followers",
                                      style: TextStyle(
                                        fontSize: Sizes.size16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Gaps.v10,
                                  isMine
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: Sizes.size48,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: Sizes.size10,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    Sizes.size10,
                                                  ),
                                                ),
                                                child: Text(
                                                  "Edit profile",
                                                  style: TextStyle(
                                                    fontSize: Sizes.size16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Gaps.h10,
                                            Expanded(
                                              child: Container(
                                                height: Sizes.size48,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: Sizes.size10,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    Sizes.size10,
                                                  ),
                                                ),
                                                child: Text(
                                                  "Share profile",
                                                  style: TextStyle(
                                                    fontSize: Sizes.size16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: FollowButton(
                                                uid: data.uid,
                                                name: data.name,
                                                isStrong: true,
                                                height: Sizes.size48,
                                              ),
                                            ),
                                            Gaps.h10,
                                            Expanded(
                                              child: Container(
                                                height: Sizes.size48,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: Sizes.size10,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    Sizes.size10,
                                                  ),
                                                ),
                                                child: Text(
                                                  "Mentions",
                                                  style: TextStyle(
                                                    fontSize: Sizes.size16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            delegate: PersistentTabBar(ref: ref),
                            pinned: true,
                          )
                        ];
                      },
                      body: TabBarView(
                        children: [
                          NotificationListener<ScrollNotification>(
                            onNotification: (notification) =>
                                _loadMore(notification),
                            child: RefreshIndicator.adaptive(
                              onRefresh: () => _onRefresh(widget.uid),
                              child: !threads.isLoading &&
                                      threads.value!.isNotEmpty
                                  ? ListView.builder(
                                      // controller: _tabBarViewScrollController,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Sizes.size10,
                                        vertical: Sizes.size20,
                                      ),
                                      itemCount: threads.value!.length +
                                          (_isLoading ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if (index < threads.value!.length) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: Sizes.size12,
                                            ),
                                            child: Thread(
                                              id: threads.value![index].id,
                                              creator:
                                                  threads.value![index].creator,
                                              creatorUid: threads
                                                  .value![index].creatorUid,
                                              createdAt: threads
                                                  .value![index].createdAt!
                                                  .toDate(),
                                              content:
                                                  threads.value![index].content,
                                              images:
                                                  threads.value![index].images,
                                              commentOf: threads
                                                  .value![index].commentOf,
                                              comments: const [],
                                              likes:
                                                  threads.value![index].likes,
                                              replies:
                                                  threads.value![index].replies,
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                                        }
                                      },
                                    )
                                  : ListView(
                                      children: const [
                                        Gaps.v60,
                                        Center(
                                          child: Text(
                                            "No my threads yet.",
                                            style: TextStyle(
                                              fontSize: Sizes.size16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          ListView(
                            children: const [
                              Gaps.v60,
                              Center(
                                child: Text(
                                  "No replies yet.",
                                  style: TextStyle(
                                    fontSize: Sizes.size16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
  }
}
