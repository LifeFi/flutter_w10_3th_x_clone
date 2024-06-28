import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/show_bottom_tap_bar.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/thread_actions_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/threads_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/post_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/avatar.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/thread.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThreadScreen extends ConsumerStatefulWidget {
  static const String routeName = "threadDetail";
  static const String routeURL = "/threads/:threadId";

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

  ThreadScreen({
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
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends ConsumerState<ThreadScreen> {
  @override
  void initState() {
    super.initState();
    // Widget 을 Build 할때, Provider refresh 를 권장하지 않는다고 함.
    // 이를 회피하기 위해, initState 함수 실행 이후, 그리고 이벤트 태스크 진행 이전에
    // Future.microtask 를 비동기로 진행함.
    Future.microtask(() {
      if (ref.read(threadActionsProvider(widget.id)).value?.comments == null) {
        ref.read(threadActionsProvider(widget.id).notifier).fetchComments();
      }
    });
  }

  Future<void> _onRefresh() async {
    if (ref.read(threadActionsProvider(widget.id)).isLoading) return;
    await ref.read(threadActionsProvider(widget.id).notifier).refresh();
  }

  Future<bool> _showPostModal() async {
    final bool isPosted;
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

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    final user = ref.watch(authRepo).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thread"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size20,
            ),
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: Gaps.v10,
                  ),
                  SliverToBoxAdapter(
                    child: Thread(
                      id: widget.id,
                      creator: widget.creator,
                      creatorUid: widget.creatorUid,
                      content: widget.content,
                      images: widget.images,
                      commentOf: widget.commentOf,
                      comments: widget.comments,
                      likes: widget.likes,
                      replies: widget.replies,
                      createdAt: widget.createdAt,
                      isLarge: true,
                    ),
                  ),
                  ref.watch(threadActionsProvider(widget.id)).when(
                        loading: () => const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(100),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        error: (error, stackTrace) => SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              'Could not load threads: $error',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        data: (data) {
                          print(data.comments);
                          return data.comments != null &&
                                  data.comments!.isNotEmpty
                              ? SliverList.builder(
                                  itemCount: data.comments!.length,
                                  itemBuilder: (context, index) => Thread(
                                    id: data.comments![index].id,
                                    creator: data.comments![index].creator,
                                    creatorUid:
                                        data.comments![index].creatorUid,
                                    content: data.comments![index].content,
                                    images: data.comments![index].images,
                                    commentOf: data.comments![index].commentOf,
                                    comments: data.comments![index].comments,
                                    likes: data.comments![index].likes,
                                    replies: data.comments![index].replies,
                                    createdAt: data.comments![index].createdAt!
                                        .toDate(),
                                  ),
                                )
                              : SliverToBoxAdapter(
                                  child: Container(),
                                );
                        },
                      ),
                  const SliverToBoxAdapter(
                    child: Gaps.v96,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom:
                  ref.read(showBottomTabBarProvider.notifier).state ? 30 : 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(
                  Sizes.size10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 0.2,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: _showPostModal,
                  child: Container(
                    height: Sizes.size40,
                    padding: const EdgeInsets.all(Sizes.size10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(Sizes.size20),
                    ),
                    child: Row(
                      children: [
                        Avatar(
                          userId: user!.uid,
                          size: 20,
                          hasFollowBtn: false,
                        ),
                        Gaps.h10,
                        Text(
                          "${widget.creator}님에게 답글 남기기",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: Sizes.size16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
