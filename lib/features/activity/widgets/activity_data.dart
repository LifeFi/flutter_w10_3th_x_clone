import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';

Map<int, String> category = {
  0: "Replied you",
  1: "Mentioned you",
  2: "Followed you",
  3: "Liked you",
};

class ActivityData extends ChangeNotifier {
  List<Map<String, dynamic>> data = [
    for (var i = 0; i < 20; i++)
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
        "createdAt": DateTime.now().subtract(
          Duration(
            minutes: random.integer(60 * 24 * 7),
          ),
        ),
        "category": random.mapElementValue(category),
        "content": faker.lorem.sentence(),
      }
  ];
}

final activityData = ActivityData();
