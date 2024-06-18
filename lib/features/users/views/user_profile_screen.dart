import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/common/widgets/thread.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/show_bottom_tap_bar.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/settings_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/users/widgets/my_feeds_darta.dart';
import 'package:flutter_w10_3th_x_clone/features/users/widgets/persistant_tab_bar.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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

  _onSettingsTap() {
    context.goNamed(
      SettingsScreen.routeName,
      pathParameters: {"tab": "profile"},
    );
    // context.goNamed(SettingsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                leadingWidth: Sizes.size60,
                leading: Row(
                  children: [
                    Gaps.h10,
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.globe),
                      iconSize: Sizes.size28,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.camera),
                    iconSize: Sizes.size28,
                  ),
                  IconButton(
                    onPressed: _onSettingsTap,
                    icon: const FaIcon(FontAwesomeIcons.barsStaggered),
                    iconSize: Sizes.size28,
                  ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Jane",
                                style: TextStyle(
                                  fontSize: Sizes.size24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Jane_mobbin",
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: Sizes.size32,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(getImage()),
                          )
                        ],
                      ),
                      Gaps.v5,
                      const Text(
                        "Plant enthusiast!",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                        ),
                      ),
                      Gaps.v10,
                      Text(
                        "2 Followers",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Gaps.v10,
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                vertical: Sizes.size10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Sizes.size10,
                                ),
                              ),
                              child: const Text(
                                "Edit profile",
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Gaps.h10,
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                vertical: Sizes.size10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Sizes.size10,
                                ),
                              ),
                              child: const Text(
                                "Share profile",
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                  fontWeight: FontWeight.bold,
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
                delegate: PersistentTabBar(),
                pinned: true,
              )
            ];
          },
          body: TabBarView(
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size10,
                  vertical: Sizes.size20,
                ),
                itemCount: myFeedsData.orderedData().length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size12,
                    ),
                    child: Thread(
                      name: myFeedsData.orderedData()[index]["user"]["name"],
                      avatar: myFeedsData.orderedData()[index]["user"]
                          ["avatar"],
                      isMe: myFeedsData.orderedData()[index]["user"]["isMe"],
                      createdAt: myFeedsData.orderedData()[index]["createdAt"],
                      content: myFeedsData.orderedData()[index]["content"],
                      images: myFeedsData.orderedData()[index]["images"],
                      comments: myFeedsData.orderedData()[index]["comments"],
                      likes: myFeedsData.orderedData()[index]["likes"],
                    ),
                  );
                },
              ),
              Container(
                child: const Center(
                  child: Text(
                    "Replies",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
