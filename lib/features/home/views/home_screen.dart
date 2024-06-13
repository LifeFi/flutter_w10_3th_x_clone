import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final List<Map<String, dynamic>> feeds = [
  for (var i = 0; i < 20; i++)
    {
      "id": random.integer(1000000),
      "user": {
        "id": random.integer(1000000),
        "name": faker.person.name(),
        // "avatar": faker.image.image(
        //   keywords: ["avatar", "profile"],
        //   height: 80,
        //   width: 80,
        //   random: true,
        // ),
        "avatar": getImage(),
      },
      "content": faker.lorem.sentence(),
      "images": [
        for (var i = 0; i < random.integer(5); i++)
          // faker.image.image(
          //   random: true,
          // ),
          getImage(),
      ],
      "createdAt": DateTime.now().subtract(
        Duration(
          minutes: random.integer(60 * 24 * 7),
        ),
      ),
      "comments": [
        for (var i = 0; i < random.integer(10); i++)
          {
            "id": random.integer(1000000),
            "name": faker.person.name(),
            // "avatar": faker.image.image(
            //   keywords: ["avatar", "profile"],
            //   height: 80,
            //   width: 80,
            //   random: true,
            // ),
            "avatar": getImage(),
          }
      ],
      "likes": random.integer(1000),
    }
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderedFeeds = List.from(feeds);
    orderedFeeds.sort(
      (a, b) => b["createdAt"].compareTo(a["createdAt"]),
    );

    String diffTimeString(DateTime dateTime) {
      final curTime = DateTime.now();
      final diffMSec =
          curTime.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;
      String result;
      if (diffMSec < 60 * 60 * 1000) {
        result = "${(diffMSec / (60 * 1000)).round()}m";
      } else if (diffMSec < 24 * 60 * 60 * 1000) {
        result = "${(diffMSec / (60 * 60 * 1000)).round()}h";
      } else {
        result = "${(diffMSec / (24 * 60 * 60 * 1000)).round()}d";
      }
      return result;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size10,
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Image.asset(
                "assets/images/threads_logo.png",
                height: Sizes.size32,
                width: Sizes.size32,
              ),
              // collapsedHeight: 100,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Gaps.v10,
              for (var feed in orderedFeeds)
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(
                            right: Sizes.size10,
                          ),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            feed["user"]["avatar"],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    feed["user"]["name"],
                                    style: const TextStyle(
                                      fontSize: Sizes.size16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    diffTimeString(feed["createdAt"]),
                                    style: TextStyle(
                                      fontSize: Sizes.size16,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Gaps.h10,
                                  const FaIcon(
                                    FontAwesomeIcons.ellipsis,
                                    size: Sizes.size16,
                                  )
                                ],
                              ),
                              Text(
                                feed["content"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: feed["images"].length > 0 ? 240 : 40,
                          margin: const EdgeInsets.only(
                            right: Sizes.size10,
                          ),
                          child: const VerticalDivider(
                            thickness: 2,
                            indent: 0,
                            endIndent: 8,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (feed["images"].length > 0)
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const SizedBox(
                                    width: 270,
                                    height: 200,
                                  ),
                                  Positioned(
                                    left: -80,
                                    width: 500,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Gaps.h80,
                                          for (var image in feed["images"])
                                            Container(
                                              width: 270,
                                              height: 200,
                                              margin: const EdgeInsets.only(
                                                top: 10,
                                                right: 10,
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Image.network(
                                                image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          Gaps.h96,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Sizes.size20,
                              ),
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.heart,
                                    size: Sizes.size20,
                                  ),
                                  Gaps.h10,
                                  FaIcon(
                                    FontAwesomeIcons.comment,
                                    size: Sizes.size20,
                                  ),
                                  Gaps.h10,
                                  FaIcon(
                                    FontAwesomeIcons.retweet,
                                    size: Sizes.size20,
                                  ),
                                  Gaps.h10,
                                  FaIcon(
                                    FontAwesomeIcons.paperPlane,
                                    size: Sizes.size18,
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 40,
                              margin: const EdgeInsets.only(
                                right: Sizes.size10,
                              ),
                            ),
                            if (feed["comments"].length > 2) ...[
                              Positioned(
                                right: 4,
                                bottom: 2,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.network(
                                    feed["comments"][0]["avatar"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 30,
                                bottom: -10,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    feed["comments"][1]["avatar"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 12,
                                bottom: -20,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Image.network(
                                    feed["comments"][2]["avatar"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ] else if (feed["comments"].length == 2) ...[
                              Positioned(
                                right: 24,
                                bottom: -10,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    feed["comments"][0]["avatar"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                bottom: -12,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 6,
                                bottom: -10,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    feed["comments"][1]["avatar"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ] else if (feed["comments"].length == 1)
                              Positioned(
                                right: 24,
                                bottom: -10,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    feed["comments"][0]["avatar"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          "${feed["comments"].length} replies ・ ${feed["likes"]} likes",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: Sizes.size16,
                          ),
                        ),
                      ],
                    ),
                    Gaps.v10,
                    const Divider(),
                    Gaps.v10,
                  ],
                ),
            ]))
          ],
        ),
      ),
    );
  }
}
