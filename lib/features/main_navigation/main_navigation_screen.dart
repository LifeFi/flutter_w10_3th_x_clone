import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/features/activity/views/activity_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/view_model/main_navigation_shell_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/search/views/search_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/home_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/users/views/user_profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  static const String routeName = "mainNavigationScreen";
  final String tab;

  const MainNavigationScreen({
    super.key,
    this.tab = "home",
  });

  @override
  MainNavigationScreenState createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "search",
    "post",
    "activity",
    "profile",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(selectedTabIndexProvider);

    int selectedIndex = _tabs.indexOf(widget.tab);

    return Stack(
      children: [
        Offstage(
          offstage: selectedIndex != 0,
          child: HomeScreen(key: homeScreenKey),
        ),
        Offstage(
          offstage: selectedIndex != 1,
          child: const SearchScreen(),
        ),
        Offstage(
          offstage: selectedIndex != 2,
          child: null,
        ),
        Offstage(
          offstage: selectedIndex != 3,
          child: const ActivityScreen(),
        ),
        Offstage(
          offstage: selectedIndex != 4,
          child: const UserProfileScreen(),
        ),
      ],
    );
  }
}
