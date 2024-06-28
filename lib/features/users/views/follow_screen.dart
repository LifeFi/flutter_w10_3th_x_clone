import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/enum.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/models/follow_data_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/follow_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/avatar.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/widgets/thread.dart';
import 'package:flutter_w10_3th_x_clone/features/users/repos/user_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/is_following_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/repos/threads_repo.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/threads_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/camera_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/view_models/post_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/widgets/follow_button.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/widgets/follow_list.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/* 
final Map<String, dynamic> user = {
  "id": random.integer(1000000),
  "name": faker.person.name(),
  "avatar": faker.image.image(
    keywords: ["avatar", "profile"],
    height: 80,
    width: 80,
    random: true,
  ),
};
 */
class FollowScreen extends ConsumerStatefulWidget {
  final String? uid;

  const FollowScreen({
    super.key,
    this.uid,
  });

  @override
  FollowScreenState createState() => FollowScreenState();
}

class FollowScreenState extends ConsumerState<FollowScreen> {
  final tabs = ["Followers", "Following"];

  _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    final user = ref.watch(usersProvider(widget.uid));
    print((ref
        .read(usersProvider(widget.uid).notifier)
        .findProfile(user.value!.uid)
        .then((value) => value!.following)));
    print(user.value?.followers);
    print(user.value?.following);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: GestureDetector(
        onTap: _onScaffoldTap,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(90.0),
              child: Container(
                color: isDark ? Colors.black : Colors.white,
                child: Column(
                  children: [
                    Gaps.v5,
                    Container(
                      height: Sizes.size5,
                      width: Sizes.size44,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(Sizes.size5)),
                    ),
                    Gaps.v10,
                    SizedBox(
                      height: Sizes.size60,
                      child: TabBar(
                        indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size10,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 1.0,
                        tabs: [
                          Tab(
                            child: Text(
                              "Followers\n${shortNumberFormat(user.value!.followers)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Following\n${shortNumberFormat(user.value!.following)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                left: Sizes.size10,
                right: Sizes.size10,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        FollowList(
                          // key: Key("${widget.uid}followers"),
                          fetchType: FollowType.followers,
                          uid: widget.uid,
                        ),
                        FollowList(
                          // key: Key("${widget.uid}following"),
                          fetchType: FollowType.following,
                          uid: widget.uid,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
