import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/activity/widgets/activity_data.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final tabs = [
  "All",
  "Follow",
  "Replies",
  "Mentions",
  "Verified",
  "Likes",
];

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final List<int> _followingList = [];

  void _onFollowTap(int id) {
    if (_followingList.contains(id)) {
      setState(() {
        _followingList.remove(id);
      });
    } else {
      setState(() {
        _followingList.add(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Activity",
                style: TextStyle(
                  fontSize: Sizes.size28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              Gaps.v5,
              TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                dividerHeight: 0,
                splashFactory: NoSplash.splashFactory,
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 1,
                ),
                // padding: const EdgeInsets.all(0),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 0,
                ),
                labelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(Sizes.size5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                tabs: [
                  for (var tab in tabs)
                    Tab(
                      // text: tab,
                      child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size10,
                          vertical: Sizes.size10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.size5),
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        child: Text(tab),
                      ),
                    ),
                ],
              ),
            ],
          ),
          toolbarHeight: Sizes.size96,
        ),
        body: TabBarView(
          children: [
            for (var tab in tabs)
              ListView.builder(
                itemCount: activityData.data.length,
                itemBuilder: (context, index) {
                  if (tab == "Follow" &&
                      activityData.data[index]["category"] != "Followed you") {
                    return Container();
                  } else if (tab == "Replies" &&
                      activityData.data[index]["category"] != "Replied you") {
                    return Container();
                  } else if (tab == "Mentions" &&
                      activityData.data[index]["category"] != "Mentioned you") {
                    return Container();
                  } else if (tab == "Follow" &&
                      activityData.data[index]["category"] != "Followed you") {
                    return Container();
                  } else if (tab == "Likes" &&
                      activityData.data[index]["category"] != "Liked you") {
                    return Container();
                  } else if (tab == "Verified" &&
                      activityData.data[index]["category"] != "Verified") {
                    return Container();
                  }
                  return ListTile(
                    title: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: Sizes.size20,
                              foregroundImage: NetworkImage(
                                activityData.data[index]["avatar"],
                              ),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: activityData.data[index]["category"] ==
                                      "Replied you"
                                  ? const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.blue,
                                      child: FaIcon(
                                        FontAwesomeIcons.reply,
                                        color: Colors.white,
                                        size: Sizes.size14,
                                      ),
                                    )
                                  : activityData.data[index]["category"] ==
                                          "Mentioned you"
                                      ? const CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.green,
                                          child: FaIcon(
                                            FontAwesomeIcons.at,
                                            color: Colors.white,
                                            size: Sizes.size14,
                                          ),
                                        )
                                      : activityData.data[index]["category"] ==
                                              "Followed you"
                                          ? const CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              child: FaIcon(
                                                FontAwesomeIcons.solidUser,
                                                color: Colors.white,
                                                size: Sizes.size12,
                                              ),
                                            )
                                          : const CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.pink,
                                              child: FaIcon(
                                                FontAwesomeIcons.solidHeart,
                                                color: Colors.white,
                                                size: Sizes.size10,
                                              ),
                                            ),
                            )
                          ],
                        ),
                        Gaps.h10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: activityData.data[index]["name"],
                                        style: const TextStyle(
                                            color: Colors.black)),
                                    TextSpan(
                                      text:
                                          " ${diffTimeString(activityData.data[index]["createdAt"])}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                activityData.data[index]["category"],
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                activityData.data[index]["content"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        activityData.data[index]["category"] == "Followed you"
                            ? GestureDetector(
                                onTap: () => _onFollowTap(
                                    activityData.data[index]["id"]),
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
                                    _followingList.contains(
                                            activityData.data[index]["id"])
                                        ? "Unfollow"
                                        : "Follow",
                                    style: const TextStyle(
                                      fontSize: Sizes.size14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
