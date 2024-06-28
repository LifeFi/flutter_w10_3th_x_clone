import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/view_model/main_navigation_shell_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/home_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/nav_tab.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/show_bottom_tap_bar.dart';
import 'package:flutter_w10_3th_x_clone/features/threads/views/post_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainNavigationShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainNavigationShell({
    super.key,
    required this.child,
  });

  @override
  MainNavigationShellState createState() => MainNavigationShellState();
}

class MainNavigationShellState extends ConsumerState<MainNavigationShell>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  @override
  bool get wantKeepAlive => true;

  final List<String> _tabs = [
    "home",
    "search",
    "post",
    "activity",
    "profile",
  ];

  Future<void> _onTap(int index) async {
    print("index: $index");
    print("seletedIndex: $_selectedIndex");
    print(
        "_seletedProvider: ${ref.read(selectedTabIndexProvider.notifier).state}");
    if (index == 2) {
      final bool isPosted;
      isPosted = await _showPostModal();
      print("isPosted: $isPosted");
      if (isPosted) {
        if (!mounted) return;
        context.go("/${_tabs[0]}");
        setState(() {
          _selectedIndex = 0;
        });
      }
    } else if (index == 0 && _selectedIndex == 0) {
      // HomeScreen 의 GlobalKey 를 생성하고, 이를 통해서 메소드 실행.
      // HomeScreen() 위젯 파일에 homeScreenKey 정의함.
      homeScreenKey.currentState?.scrollToTop();
    } else {
      ref.read(selectedTabIndexProvider.notifier).state = index;
      // ref.read(selectedTabIndexProvider.notifier).state = index; 를 원래 setState 안에 넣었으나
      // WEB에서(iOS는 OK), wiget build 전에 update가 일어난다는 오류 발생하여
      // setState 이전 단계로 옮겼음.
      setState(() {});
      print("context.go!!!!!!!!!!!");
      context.go("/${_tabs[index]}");
      // context.push("/${_tabs[index]}");
    }
  }

  Future<bool> _showPostModal() async {
    final bool isPosted;
    isPosted = await showModalBottomSheet(
          isScrollControlled: true,
          elevation: 0,
          context: context,
          builder: (context) => const PostScreen(),
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
    return isPosted;
  }

  void _toggleShowBottomTabBar() {
    ref.read(showBottomTabBarProvider.notifier).update((state) => !state);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 빌드 함수 내에 있어야, 브라우저 백키시 제대로 변경됨.
    ref.watch(showBottomTabBarProvider);
    ref.watch(selectedTabIndexProvider);
    _selectedIndex = ref.read(selectedTabIndexProvider.notifier).state;
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: _toggleShowBottomTabBar,
        child: Stack(
          children: [
            widget.child,
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSlide(
                offset: Offset(
                  0,
                  ref.read(showBottomTabBarProvider.notifier).state ? 0 : 1.0,
                ),
                duration: const Duration(milliseconds: 150),
                child: Container(
                  height: Sizes.size80,
                  padding: const EdgeInsets.only(
                    top: Sizes.size20,
                    bottom: Sizes.size32,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NavTab(
                        isSelected: _selectedIndex == 0,
                        icon: FontAwesomeIcons.house,
                        selectedIcon: FontAwesomeIcons.house,
                        onTap: () => _onTap(0),
                      ),
                      NavTab(
                        isSelected: _selectedIndex == 1,
                        icon: FontAwesomeIcons.magnifyingGlass,
                        selectedIcon: FontAwesomeIcons.magnifyingGlass,
                        onTap: () => _onTap(1),
                      ),
                      NavTab(
                        isSelected: _selectedIndex == 2,
                        icon: FontAwesomeIcons.penToSquare,
                        selectedIcon: FontAwesomeIcons.penToSquare,
                        onTap: () => _onTap(2),
                      ),
                      NavTab(
                        isSelected: _selectedIndex == 3,
                        icon: FontAwesomeIcons.heart,
                        selectedIcon: FontAwesomeIcons.solidHeart,
                        onTap: () => _onTap(3),
                      ),
                      NavTab(
                        isSelected: _selectedIndex == 4,
                        icon: FontAwesomeIcons.user,
                        selectedIcon: FontAwesomeIcons.userLarge,
                        onTap: () => _onTap(4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
