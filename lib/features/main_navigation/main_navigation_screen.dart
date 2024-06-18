import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/activity/views/activity_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/home/views/home_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/nav_tab.dart';
import 'package:flutter_w10_3th_x_clone/features/post/view/post_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/search/views/search_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  Future<void> _onTap(int index) async {
    if (index == 2) {
      final bool isPosted;
      isPosted = await _showPostModal();
      if (isPosted) {
        setState(() {
          _selectedIndex = 0;
        });
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.size16),
          ),
        ) ??
        false;
    return isPosted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const HomeScreen(),
          ),
          Offstage(offstage: _selectedIndex != 1, child: const SearchScreen()),
          Offstage(
            offstage: _selectedIndex != 2,
            child: const Placeholder(
              child: Center(
                child: Text(
                  "Post",
                  style: TextStyle(
                    fontSize: Sizes.size28,
                  ),
                ),
              ),
            ),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const ActivityScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const Placeholder(
              child: Center(
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: Sizes.size28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Row(
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
    );
  }
}
