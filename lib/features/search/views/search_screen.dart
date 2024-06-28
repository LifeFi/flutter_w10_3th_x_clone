import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/main_navigation/widgets/show_bottom_tap_bar.dart';
import 'package:flutter_w10_3th_x_clone/features/search/view_models/recent_keywords_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/search/views/search_result_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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

  // void _onFollowTap(int id) {
  //   if (_followingList.contains(id)) {
  //     setState(() {
  //       _followingList.remove(id);
  //       searchUsersData.unfollow(id);
  //     });
  //   } else {
  //     setState(() {
  //       _followingList.add(id);
  //       searchUsersData.follow(id);
  //     });
  //   }
  // }

  _onSearchSubmitted(String keyword) {
    ref.read(recentKeywordsProvider.notifier).addKeyword(keyword);
    print(ref.read(recentKeywordsProvider));

    context.pushNamed(
      SearchResultScreen.routeName,
      pathParameters: {"keyword": keyword},
    );

    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => SearchResultScreen(
    //       keyword: keyword,
    //     ),
    //   ),
    // );
    setState(
      () {},
    );
  }

  _removeAllKeywords() {
    ref.read(recentKeywordsProvider.notifier).removeAllKeywords();
  }

  _removeKeyword(String keyword) {
    ref.read(recentKeywordsProvider.notifier).removeKeyword(keyword);
  }

  // _onSearchChanged(String value) {
  //   setState(
  //     () {},
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final recentKeywords = ref.watch(recentKeywordsProvider);
    print(recentKeywords);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Search",
              style: TextStyle(
                  fontSize: Sizes.size28, fontWeight: FontWeight.bold),
            ),
            Gaps.v10,
            CupertinoSearchTextField(
              controller: _controller,
              onSubmitted: (keyword) => _onSearchSubmitted(keyword),
              // onChanged: (value) => _onSearchChanged(value),
            ),
          ],
        ),
        toolbarHeight: Sizes.size96,
      ),
      body: recentKeywords.isNotEmpty
          ? ListView(
              children: [
                Gaps.v14,
                Padding(
                  padding: const EdgeInsets.only(
                    left: Sizes.size10,
                    right: Sizes.size20,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Recent Keywords",
                        style: TextStyle(
                          fontSize: Sizes.size18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _removeAllKeywords,
                        child: const Text(
                          "Clear",
                          style: TextStyle(
                            fontSize: Sizes.size14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.v10,
                for (var keyword in recentKeywords)
                  ListTile(
                    onTap: () => _onSearchSubmitted(keyword),
                    contentPadding: const EdgeInsets.only(
                      left: Sizes.size24,
                      right: Sizes.size24,
                      top: 0,
                      bottom: 0,
                    ),
                    leading: Column(
                      children: [
                        Gaps.v10,
                        FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: Sizes.size20,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ],
                    ),
                    title: Column(
                      children: [
                        Gaps.v5,
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                keyword,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                            ),
                            Gaps.h5,
                            GestureDetector(
                              onTap: () => _removeKeyword(keyword),
                              child: FaIcon(
                                FontAwesomeIcons.xmark,
                                color: Colors.grey.withOpacity(0.7),
                                size: Sizes.size18,
                              ),
                            ),
                            Gaps.h2
                          ],
                        ),
                        Gaps.v24,
                        const Divider(
                          height: Sizes.size1,
                          thickness: 0.5,
                        )
                      ],
                    ),
                  ),
                Gaps.v96,
              ],
            )
          : null,
    );
  }
}
