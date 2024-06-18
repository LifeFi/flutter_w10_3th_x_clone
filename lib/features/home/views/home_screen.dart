import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/common/widgets/thread.dart';
import 'package:flutter_w10_3th_x_clone/features/home/views/widgets/feeds_data.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/show_bottom_tap_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  _toggleShowBottomTabBar() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        showBottomTabBar.value) {
      showBottomTabBar.value = false;
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        !showBottomTabBar.value) {
      showBottomTabBar.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_toggleShowBottomTabBar);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size10,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              title: Image.asset(
                "assets/images/threads_logo.png",
                height: Sizes.size32,
                width: Sizes.size32,
              ),
              // collapsedHeight: 100,
            ),
            AnimatedBuilder(
              animation: feedsData,
              builder: (context, child) => SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Gaps.v10,
                    for (var feed in feedsData.orderedData())
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size12,
                        ),
                        child: Thread(
                          name: feed["user"]["name"],
                          avatar: feed["user"]["avatar"],
                          isMe: feed["user"]["isMe"],
                          createdAt: feed["createdAt"],
                          content: feed["content"],
                          images: feed["images"],
                          comments: feed["comments"],
                          likes: feed["likes"],
                        ),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
