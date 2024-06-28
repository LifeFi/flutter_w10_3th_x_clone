import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/common/widgets/more_modalbottomsheet.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/main_navigation_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/show_bottom_tap_bar.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/follow_data_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/follow_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/thread_actions_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/post_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/thread_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/avatar.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/is_following_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/user_profile_screen.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class Thread extends ConsumerStatefulWidget {
  final String id;
  final String creator;
  final String creatorUid;
  final String content;
  List<String>? images;
  final String commentOf;
  List<CommentModel>? comments;
  int likes;
  int replies;
  final DateTime createdAt;
  final bool isLarge;

  Thread({
    super.key,
    required this.id,
    required this.creator,
    required this.creatorUid,
    required this.content,
    this.images,
    required this.commentOf,
    this.comments,
    required this.likes,
    required this.replies,
    required this.createdAt,
    this.isLarge = false,
  });
  @override
  ThreadState createState() => ThreadState();
}

class ThreadState extends ConsumerState<Thread> {
  void _onMoreTap(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      elevation: 0,
      context: context,
      builder: (context) => const MoreModalbottomsheet(),
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.size16),
          topRight: Radius.circular(Sizes.size16),
        ),
      ),
    );
  }

  void _onCreatorTap(BuildContext context, String? creatorUid, bool isMine) {
    if (isMine) {
      return;
      // MainNavigationScreen 중복 생성되는 문제로 우선 막음.
      // 근본적으로 GoRouter 구조를 변경해야 할 듯.
      // 예시 ) ShellRoute 로 BottomNavigationTabBar 를 붙이고
      //        AutomaticKeepAliveClientMixin 를 with 로 포함시키고
      //        build 함수의 return 전에,    super.build(context); 를 포함시킨다.
    } else {
      context.pushNamed(
        UserProfileScreen.routeName,
        pathParameters: {"uid": creatorUid!},
      );
      // context.push("/profile/$creatorUid");

      // context.pushNamed(
      //   MainNavigationScreen.routeName,
      //   pathParameters: {"tab": "profile"},
      //   queryParameters: {"uid": creatorUid},
      // );

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => UserProfileScreen(uid: creatorUid),
      //   ),
      // );
    }
  }

  void _goToThreadScreen() async {
    // if (ref.read(threadActionsProvider(widget.id)).value?.comments == null) {
    //   await ref.read(threadActionsProvider(widget.id).notifier).fetchComments();
    // }
    if (!mounted) return;

    context.pushNamed(
      ThreadScreen.routeName,
      pathParameters: {"threadId": widget.id},
      extra: ThreadModel(
        id: widget.id,
        creatorUid: widget.creatorUid,
        creator: widget.creator,
        content: widget.content,
        images: widget.images!,
        commentOf: widget.commentOf,
        comments: [],
        likes: widget.likes,
        replies: widget.replies,
        createdAt: Timestamp.fromDate(widget.createdAt),
      ),
    );

    /* 
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ThreadScreen(
        id: widget.id,
        creator: widget.creator,
        creatorUid: widget.creatorUid,
        content: widget.content,
        images: widget.images,
        commentOf: widget.commentOf,
        likes: widget.likes,
        replies: widget.replies,
        createdAt: widget.createdAt,
      ),
    ));
    */
  }

  Future<void> _onToggleLike() async {
    if (ref.read(threadActionsProvider(widget.id)).isLoading) return;
    ref.read(threadActionsProvider(widget.id)).value!.isLiked
        ? --widget.likes
        : ++widget.likes;
    await ref.read(threadActionsProvider(widget.id).notifier).likeThread();

    setState(() {});
  }

  Future<bool> _showPostModal() async {
    final bool isPosted;
    ref.read(showBottomTabBarProvider.notifier).state = false;
    isPosted = await showModalBottomSheet(
          isScrollControlled: true,
          elevation: 0,
          context: context,
          builder: (context) => PostScreen(
            commentOf: widget.id,
            creator: widget.creator,
            creatorUid: widget.creatorUid,
            content: widget.content,
          ),
          backgroundColor: Colors.white,
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Sizes.size16),
              topRight: Radius.circular(Sizes.size16),
            ),
          ),
        ) ??
        false;

    if (isPosted) {
      ++widget.replies;
      setState(() {});
    }

    return isPosted;
  }

  Future<void> _onFollowTap() async {
    await ref.read(followProvider.notifier).followUser(
          FollowDataModel(
            uid: widget.creatorUid,
            name: widget.creator,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    final isMine = ref.watch(authRepo).user!.uid == widget.creatorUid;
    final myFollowing = ref.watch(isFollowingProvider).value?.myFollowing;

    // print("${widget.creator} / ${widget.content} / $_isLiked");
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isLarge)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: isMine
                          ? () {}
                          : (myFollowing != null &&
                                  myFollowing.contains(widget.creatorUid))
                              ? () {}
                              : _onFollowTap,
                      child: Avatar(
                        userId: widget.creatorUid,
                        size: Sizes.size40,
                        hasFollowBtn: isMine
                            ? false
                            : (myFollowing != null &&
                                    myFollowing.contains(widget.creatorUid))
                                ? false
                                : true,
                        userName: widget.creator,
                      ),
                    ),
                    if (widget.replies > 0)
                      const Expanded(
                        child: VerticalDivider(
                          thickness: 2,
                          indent: 8,
                          endIndent: 34,
                        ),
                      ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          margin: const EdgeInsets.only(
                            right: Sizes.size10,
                          ),
                        ),
                        if (widget.replies > 2) ...[
                          Positioned(
                            right: 4,
                            bottom: 8,
                            child: Avatar(
                              userId: widget.creatorUid,
                              size: 22,
                              hasFollowBtn: false,
                            ),
                          ),
                          Positioned(
                            right: 30,
                            bottom: 0,
                            child: Avatar(
                              userId: widget.creatorUid,
                              size: 18,
                              hasFollowBtn: false,
                            ),
                          ),
                          Positioned(
                            right: 14,
                            bottom: -10,
                            child: Avatar(
                              userId: widget.creatorUid,
                              size: 14,
                              hasFollowBtn: false,
                            ),
                          )
                        ] else if (widget.replies == 2) ...[
                          Positioned(
                            right: 24,
                            bottom: 0,
                            child: Avatar(
                              userId: widget.creatorUid,
                              size: 18,
                              hasFollowBtn: false,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            bottom: 0,
                            child: Avatar(
                              userId: widget.creatorUid,
                              size: 18,
                              hasFollowBtn: false,
                            ),
                          ),
                        ] else if (widget.replies == 1)
                          Positioned(
                            right: 5,
                            bottom: -10,
                            child: Avatar(
                              userId: widget.creatorUid,
                              size: 40,
                              hasFollowBtn: false,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              Gaps.h5,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (widget.isLarge) ...[
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: isMine
                                    ? () {}
                                    : (myFollowing != null &&
                                            myFollowing
                                                .contains(widget.creatorUid))
                                        ? () {}
                                        : _onFollowTap,
                                child: Avatar(
                                  userId: widget.creatorUid,
                                  size: Sizes.size40,
                                  hasFollowBtn: isMine
                                      ? false
                                      : (myFollowing != null &&
                                              myFollowing
                                                  .contains(widget.creatorUid))
                                          ? false
                                          : true,
                                  userName: widget.creator,
                                ),
                              ),
                            ],
                          ),
                          Gaps.h10
                        ],
                        GestureDetector(
                          onTap: () =>
                              _onCreatorTap(context, widget.creatorUid, isMine),
                          child: Text(
                            widget.creator,
                            style: const TextStyle(
                              fontSize: Sizes.size16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            diffTimeString(widget.createdAt),
                            style: const TextStyle(
                              fontSize: Sizes.size16,
                            ),
                          ),
                        ),
                        Gaps.h10,
                        GestureDetector(
                          onTap: () => _onMoreTap(context),
                          behavior: HitTestBehavior.opaque,
                          child: const FaIcon(
                            FontAwesomeIcons.ellipsis,
                            size: Sizes.size16,
                          ),
                        )
                      ],
                    ),
                    if (widget.isLarge) Gaps.v10,
                    GestureDetector(
                      onTap: _goToThreadScreen,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          widget.content,
                          // overflow: TextOverflow.ellipsis,
                          // maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: Sizes.size16,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.images != null && widget.images!.isNotEmpty)
                          GestureDetector(
                            onTap: _goToThreadScreen,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const SizedBox(
                                  width: 270,
                                  height: 200,
                                ),
                                Positioned(
                                  left: -80,
                                  width: 500,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Gaps.h80,
                                        for (var image in widget.images!)
                                          Container(
                                            width: 270,
                                            height: 200,
                                            margin: const EdgeInsets.only(
                                              top: 10,
                                              right: 10,
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: image[0] == "/"
                                                ? Image.file(
                                                    File(image),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        Gaps.h96,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Sizes.size20,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: _onToggleLike,
                                child: !ref
                                            .watch(threadActionsProvider(
                                                widget.id))
                                            .isLoading &&
                                        ref
                                            .watch(threadActionsProvider(
                                                widget.id))
                                            .value!
                                            .isLiked
                                    ? const FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        size: Sizes.size24,
                                        color: Colors.red,
                                      )
                                    : const FaIcon(
                                        FontAwesomeIcons.heart,
                                        size: Sizes.size24,
                                      ),
                              ),
                              Gaps.h14,
                              GestureDetector(
                                onTap: _showPostModal,
                                child: const FaIcon(
                                  FontAwesomeIcons.comment,
                                  size: Sizes.size24,
                                ),
                              ),
                              Gaps.h14,
                              FaIcon(
                                FontAwesomeIcons.retweet,
                                size: Sizes.size24,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              Gaps.h14,
                              FaIcon(
                                FontAwesomeIcons.paperPlane,
                                size: Sizes.size20,
                                color: Colors.grey.withOpacity(0.7),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _goToThreadScreen,
                          child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              "${widget.replies} replies ・ ${widget.likes} likes",
                              style: const TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Gaps.v20,
        const Divider(),
        Gaps.v14,
      ],
    );
  }
}
