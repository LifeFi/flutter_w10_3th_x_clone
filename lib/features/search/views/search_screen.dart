import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/search/widgets/search_users_data.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<int> _followingList = [];

  void _onFollowTap(int id) {
    if (_followingList.contains(id)) {
      setState(() {
        _followingList.remove(id);
        searchUsersData.unfollow(id);
      });
    } else {
      setState(() {
        _followingList.add(id);
        searchUsersData.follow(id);
      });
    }
  }

  _onSearchSubmitted(String value) {
    setState(
      () {},
    );
  }

  _onSearchChanged(String value) {
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
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
              onSubmitted: (value) => _onSearchSubmitted(value),
              onChanged: (value) => _onSearchChanged(value),
            ),
          ],
        ),
        toolbarHeight: Sizes.size96,
      ),
      body: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: searchUsersData.data.length,
        itemBuilder: (context, index) {
          if (!searchUsersData.data[index]["name"]
                  .toString()
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase()) &&
              !searchUsersData.data[index]["bio"]
                  .toString()
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase())) {
            return Container();
          }
          return ListTile(
            title: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: Sizes.size20,
                      foregroundImage: NetworkImage(
                        searchUsersData.data[index]["avatar"],
                      ),
                    ),
                    Gaps.h10,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  searchUsersData.data[index]["name"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: Sizes.size14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Gaps.h8,
                                SizedBox(
                                  width: 20,
                                  child: FaIcon(
                                    FontAwesomeIcons.solidCircleCheck,
                                    color: Theme.of(context).primaryColor,
                                    size: Sizes.size16,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            searchUsersData.data[index]["bio"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: Sizes.size14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Gaps.v6,
                          Text(
                            "${shortNumberFormat(searchUsersData.data[index]["followers"])} followers",
                            style: const TextStyle(
                              fontSize: Sizes.size14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          _onFollowTap(searchUsersData.data[index]["id"]),
                      child: Container(
                        width: 94,
                        height: 36,
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size5,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            )),
                        child: Text(
                          _followingList
                                  .contains(searchUsersData.data[index]["id"])
                              ? "Unfollow"
                              : "Follow",
                          style: const TextStyle(
                            fontSize: Sizes.size14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.v10,
                Divider(
                  height: 0,
                  indent: Sizes.size48,
                  color: Colors.grey.shade200,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
