import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersistentTabBar extends SliverPersistentHeaderDelegate {
  WidgetRef ref;

  PersistentTabBar({
    required this.ref,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: const TabBar(
        indicatorPadding: EdgeInsets.symmetric(
          horizontal: Sizes.size10,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(
            child: Text(
              "Threads",
              style: TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Tab(
            child: Text(
              "Replies",
              style: TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
