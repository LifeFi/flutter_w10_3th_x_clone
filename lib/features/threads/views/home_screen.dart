import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/threads_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/thread.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/show_bottom_tap_bar.dart';

// Home 선택되어 있을때, 하단 Homed 탭하면, scrollToTop() 함수를 호출하기 위해 키 생성.
// 키를 생성하면, 다른 위젯에서 해당 위젯을 함수를 호출할 수 있다고 함.
// 글로벌 키는 사용을 절제하라고 함. ( 플러터 설계 원칙에 어긋난다고. )
GlobalKey<HomeScreenState> homeScreenKey = GlobalKey();

class HomeScreen extends ConsumerStatefulWidget {
  // const HomeScreen({super.key});
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isMoreLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print("Home init!!!!!!!!!");
    _scrollController.addListener(_toggleShowBottomTabBar);
    _scrollController.addListener(_fetchNextItems);
  }

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

  void scrollToTop() {
    _scrollController.animateTo(
      0, // 스크롤 맨 위로 이동
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _fetchNextItems() async {
    // print(
    //     "${_scrollController.position.pixels} ====  ${_scrollController.position.maxScrollExtent}");
    if (_isMoreLoading) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      // 리스트 하단에 로딩바를 보여주기 위함.
      setState(() {
        _isMoreLoading = true;
      });
      await ref.read(threadsProvider(null).notifier).fetchNextItems();
      setState(() {
        _isMoreLoading = false;
      });
    }
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  //   print("Home dispose!!!!!!!!!");
  // }

  Future<void> _onRefresh() async {
    if (ref.read(threadsProvider(null)).isLoading) return;
    ref.read(threadsProvider(null).notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size10,
        ),
        child: RefreshIndicator.adaptive(
          onRefresh: _onRefresh,
          displacement: 50,
          edgeOffset: 20,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                centerTitle: true,
                title: SvgPicture.asset(
                  'assets/images/thread.svg',
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
                // collapsedHeight: 100,
              ),
              const SliverToBoxAdapter(
                child: Gaps.v10,
              ),
              ref.watch(threadsProvider(null)).when(
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
                    data: (threads) {
                      // print(threads.length);
                      return SliverList.builder(
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
                          });
                    },
                  ),
              const SliverToBoxAdapter(
                child: Gaps.v40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
